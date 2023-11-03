WITH raw_data AS (
	SELECT
        *
	FROM
		store_data
	WHERE
		customerid <> 0
),

-- Records with quantity and unitprice > 0
quantity_unit_price AS (
	SELECT
		*
	FROM
		raw_data
	WHERE
		quantity > 0
	AND
		unitprice > 0
),

-- duplicate check
duplicate_check AS (
	SELECT
		*,
		ROW_NUMBER() OVER (
			PARTITION BY
				invoiceno,
				stockcode,
				quantity
			ORDER BY
				invoicedate
		) AS duplicate_flag
	FROM
		quantity_unit_price
)
