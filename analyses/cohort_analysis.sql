
{# 
    -- Unique Identifier (userid)
    -- Initial start date (first invoice date)
    -- revenue data
#}

cleaned_data AS (
	SELECT
		*
	FROM
		duplicate_check
	WHERE
		duplicate_flag = 1
),

online_store_main AS (
	SELECT 
		customerid,
		MIN(invoicedate) AS first_purchase,
		concat(to_char(MIN(invoicedate), 'YYYY-MM'),'-', '01') AS cohort_date
	FROM
		cleaned_data
	GROUP BY
		customerid
),

-- Cohort index, number of months that has passed since the customers first engagement
cohort_retention AS (
	SELECT
		m.*,
		c.cohort_date,
		EXTRACT(YEAR FROM m.invoicedate) AS invoice_year,
		EXTRACT(MONTH FROM m.invoicedate) AS invoice_month,
		EXTRACT(YEAR FROM c.cohort_date::date) AS cohort_year,
		EXTRACT(MONTH FROM c.cohort_date::date) AS cohort_month,
		(EXTRACT(YEAR FROM m.invoicedate) - EXTRACT(YEAR FROM c.cohort_date::date)) AS year_diff,
		(EXTRACT(MONTH FROM m.invoicedate) - EXTRACT(MONTH FROM c.cohort_date::date)) AS month_diff,
		(
			(EXTRACT(YEAR FROM m.invoicedate) - EXTRACT(YEAR FROM c.cohort_date::date)) * 12 +
			(EXTRACT(MONTH FROM m.invoicedate) - EXTRACT(MONTH FROM c.cohort_date::date)) + 1
		) AS cohort_index
	FROM
		cleaned_data m
	LEFT JOIN
		online_store_main c
	ON
		m.customerid = c.customerid
),
-- Pivot data to see cohort table
cohort_table AS (
	SELECT
		cohort_date,
		COUNT(DISTINCT CASE WHEN cohort_index = 1 THEN customerid END) AS month_1,
		COUNT(DISTINCT CASE WHEN cohort_index = 2 THEN customerid END) AS month_2,
		COUNT(DISTINCT CASE WHEN cohort_index = 3 THEN customerid END) AS month_3,
		COUNT(DISTINCT CASE WHEN cohort_index = 4 THEN customerid END) AS month_4,
		COUNT(DISTINCT CASE WHEN cohort_index = 5 THEN customerid END) AS month_5,
		COUNT(DISTINCT CASE WHEN cohort_index = 6 THEN customerid END) AS month_6,
		COUNT(DISTINCT CASE WHEN cohort_index = 7 THEN customerid END) AS month_7,
		COUNT(DISTINCT CASE WHEN cohort_index = 8 THEN customerid END) AS month_8,
		COUNT(DISTINCT CASE WHEN cohort_index = 9 THEN customerid END) AS month_9,
		COUNT(DISTINCT CASE WHEN cohort_index = 10 THEN customerid END) AS month_10,
		COUNT(DISTINCT CASE WHEN cohort_index = 11 THEN customerid END) AS month_11,
		COUNT(DISTINCT CASE WHEN cohort_index = 12 THEN customerid END) AS month_12,
		COUNT(DISTINCT CASE WHEN cohort_index = 13 THEN customerid END) AS month_13
	FROM
		cohort_retention
	GROUP BY
		1
	ORDER BY
		1
)

SELECT
	cohort_date,
	ROUND((1.0 * month_1 / month_1), 2) AS month_1_perc,
	ROUND((1.0 * month_2 / month_1), 2) AS month_2_perc,
	ROUND((1.0 * month_3 / month_1), 2) AS month_3_perc,
	ROUND((1.0 * month_4 / month_1), 2) AS month_4_perc,
	ROUND((1.0 * month_5 / month_1), 2) AS month_5_perc,
	ROUND((1.0 * month_6 / month_1), 2) AS month_6_perc,
	ROUND((1.0 * month_7 / month_1), 2) AS month_7_perc,
	ROUND((1.0 * month_8 / month_1), 2) AS month_8_perc,
	ROUND((1.0 * month_9 / month_1), 2) AS month_9_perc,
	ROUND((1.0 * month_10 / month_1), 2) AS month_10_perc,
	ROUND((1.0 * month_11 / month_1), 2) AS month_11_perc,
	ROUND((1.0 * month_12 / month_1), 2) AS month_12_perc,
	ROUND((1.0 * month_13 / month_1), 2) AS month_13_perc
FROM
	cohort_table
;
