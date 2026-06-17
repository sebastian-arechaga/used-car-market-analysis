CREATE OR ALTER VIEW vehicles_analysis AS
	SELECT
	*
	FROM vehicles_clean
	WHERE price BETWEEN 100 AND 500000
		AND year >= 2000
		AND odometer BETWEEN 100 AND 400000