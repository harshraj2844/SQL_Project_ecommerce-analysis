
Olist E-Commerce SQL Analysis

An end-to-end PostgreSQL project: raw CSVs → validated, constrained relational database → 10 business-question analyses answered in pure SQL.

Dataset: Olist Brazilian E-Commerce Public Dataset — ~100K orders from a Brazilian multi-seller marketplace, covering 2016–2018.

Tools: PostgreSQL, pgAdmin, VS Code SQL tooling.

Project Structure
sql_load/          Build & validate the database (6 files)
sql_queries/       Answer 10 business questions in SQL (10 files)
csv_files/         Raw source data
Part 1 — Building the Database (sql_load/)
File	Purpose
01_create_database.sql	Creates the olist_operations database
02_create_tables.sql	Defines the 9-table schema with explicit types
03_load_data.sql	Bulk-loads all 9 CSVs via \copy
04_data_quality.sql	Full audit: row counts, nulls, duplicates, referential integrity, and logical consistency
05_add_constraints.sql	Adds PRIMARY KEY, FOREIGN KEY, and CHECK constraints
06_add_indexes.sql	Indexes foreign key columns not already covered by a primary key
Key Design Decisions
Zip code columns are VARCHAR(5), not INT — 24–33% of zip codes across customers, sellers, and geolocation have a leading zero, which an integer type would silently strip.
Loads use \copy, not server-side COPY — runs under the client's file permissions instead of requiring direct server filesystem access.
Data Quality Audit — Key Findings

A four-layer audit (volume → column-level nulls → row-level uniqueness → cross-table/cross-column consistency) surfaced:

Finding	Detail
review_id is not unique	814 duplicate values — excluded from PRIMARY KEY candidacy
geolocation has no natural key	~26% exact full-row duplicates by design; no PRIMARY KEY added
2 product categories missing translations	Resolved with a targeted data patch before adding the FK
830 orphaned payment rows	Payments referencing an order with zero matching line items (775 distinct orders)
1,382 logically impossible date sequences	Carrier/delivery dates preceding an earlier stage of the same order
8 status/data mismatches	Orders marked delivered with no delivery date on file

Final schema: 7 primary keys (5 single-column, 2 composite), 7 foreign keys, 4 check constraints, 6 indexes. order_reviews.review_id and the geolocation table are intentionally left without a primary key for the reasons above.

Part 2 — Business Analysis (sql_queries/)

Every question follows the same structure: Business Question → SQL Analysis → Key Finding → Business Recommendation.

01_create_view.sql sets up a valid_orders view (built on the audit above) that excludes the 1,382+8 rows with impossible date sequences and status/date mismatches — every downstream file that touches delivery timing builds on this view instead of re-filtering the raw orders table.

Q1 — Total revenue and how it changed over time

(02_revenue_analysis.sql)

Finding: Total revenue is R$15.42M across 96,478 delivered orders. Revenue grew steadily through 2017, peaking at R$1.15M in November 2017 (likely a Black Friday effect), then plateaued in the R$1.0–1.13M/month range from March 2018 onward — the business shifted from early growth into a maturing, steady-state phase.

Recommendation: Investigate whether the November 2017 spike is repeatable seasonal demand worth planning around. The 2018 plateau is a "growth has stalled" signal, distinct from — and less urgent than — an actual decline.

Q2 — Which product categories drive the most revenue?

(03_product_analysis.sql)

Finding: health_beauty, watches_gifts, and bed_bath_table are the only categories crossing R$1M. The top 10 categories (of 74) generate 62.4% of total revenue — a concentrated business.

Recommendation: Focus inventory, seller recruitment, and marketing on the top 10. Separately, computers stands out with 2× the revenue-per-order of any other major category despite low volume — a distinct high-ticket growth opportunity.

Q3 — Which sellers drive the most revenue, and how concentrated is it?

(04_seller_analysis.sql)

Finding: The opposite pattern from Q2 — seller revenue is a long tail. The top 10 sellers account for only 13.3% of revenue; it takes the top 100 (of 2,970) to reach 45.5%.

Recommendation: No dominant seller to build a VIP strategy around. Growth efforts are better aimed at the mid-tier (ranked ~20–100), who show real capability without top-tier scale yet.

Q4 — Which states/cities generate the most sales?

(05_geographic_analysis.sql)

Finding: São Paulo state alone drives 37.4% of revenue; the top 3 states (SP, RJ, MG) drive 62.6%, out of 27 total states.

Recommendation: Revenue concentration in the southeast may be partly reinforced by that region's superior delivery performance (see Q6) rather than purely reflecting demand — worth testing before assuming it's a fixed ceiling elsewhere.

Q5 — Average order value, overall and by category

(06_customer_analysis.sql)

Finding: Mean AOV is R$159.86, but the median is only R$105.28 — a handful of large orders pull the average up. AOV varies 16× across categories, from computers (R$1,290) to electronics (R$79.75).

Recommendation: High-volume, low-AOV categories (electronics, telephony) are strong candidates for bundling/minimum-order promotions — a small AOV lift there moves more total revenue than the same lift in a low-volume category.

Q6 — Delivery time and factors behind late deliveries

(07_delivery_analysis.sql)

Finding: Average delivery is 12.2 days (median 10), with an overall 8.19% late rate. Lateness is heavily geographic, not calendar-driven: day-of-week purchase barely moves the rate (7.6–9.1%), but northeastern states show 15–24% late rates — more than double the platform average, potentially reflecting their greater distance from the southeast fulfillment hub.

Recommendation: This appears more like a logistics/distance problem than a scheduling one. Regional fulfillment partnerships in the underperforming states could help address the underlying issue.

Q7 — Customer satisfaction and what drives low scores

(08_customer_satisfaction.sql)

Finding: Average review score is 4.09/5, with a bimodal distribution (57.8% give a 5, 11.5% give a 1 — few in between). The single strongest relationship found: late delivery drops average score from 4.29 to 2.57 — a much larger effect than any category-level difference.

Recommendation: Delivery reliability is the highest-leverage satisfaction lever, not product quality. Fixing lateness in the Q6 hotspot states could potentially move platform-wide satisfaction more than any category-specific fix.

Q8 — Repeat purchases and retention

(09_customer_retention.sql)

Finding: Repeat purchase rate is just 3.0% (2,801 of 93,358 unique customers, correctly grouped by customer_unique_id). Repeat customers generate a disproportionately small 5.6% of revenue.

Recommendation: This is close to a single-purchase marketplace today. Given Q7's delivery-satisfaction link, testing whether a customer's first-order delivery experience predicts whether they return is a natural, high-value follow-up analysis.

Q9 — Categories/sellers with the highest cancellation or late-delivery rates

(10_business_opportunities.sql)

Finding: Cancellation is not a systemic issue — every category stays under 3.4%, every seller (30+ orders) under 7.2%. No red flags at scale.

Recommendation: No cancellation-specific intervention needed; this isn't where the platform's operational risk lives (delivery timing, per Q6, is the more significant lever).

Q10 — Categories/sellers with strong sales but poor satisfaction or delivery

(10_business_opportunities.sql)

Finding — the strongest result in the project: office_furniture is the 15th highest-revenue category but has by far the worst review score (3.52) of any top-15 category, well under the 4.09 average. One top-5 revenue seller (973 orders) has an average score of just 3.35, the worst of any major seller.

Recommendation: office_furniture and that specific seller are the clearest "fix this" opportunities in the whole dataset — real revenue at stake, actively affected by poor fulfillment/satisfaction (per Q7/Q8). A seller-level operational audit is the single highest-leverage next step, given the order volume that one seller alone represents.

Skills Demonstrated
Schema design with explicit type decisions grounded in real data inspection (not defaults)
Systematic 4-layer data quality auditing (UNION ALL reporting, scalar subqueries, NOT EXISTS anti-joins)
Constraint-ordering-aware DDL (data fixes → primary keys → foreign keys → checks → indexes)
Window functions (LAG, RANK, running/grand totals via SUM() OVER())
PERCENTILE_CONT for median calculations alongside means
COALESCE-based fallback logic for incomplete reference data
Correct grouping-key selection for retention analysis (customer_unique_id vs. customer_id)
Cross-metric synthesis — connecting findings across files (Q4↔Q6, Q7↔Q8, Q2/Q3↔Q10) rather than treating each question in isolation
