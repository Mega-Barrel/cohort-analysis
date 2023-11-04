
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
)

-- Cohort index, number of months that has passed since the customers first engagement
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
;