DECLARE @d_start DATETIME
DECLARE @d_end DATETIME

SET @d_start = '20220101'
SET @d_end = '20230101'
SET LANGUAGE Russian

SELECT r.date_
	,CAST(YEAR(r.date_) AS VARCHAR(4)) + CASE 
		WHEN DATEPART(ww, r.date_) < 10
			THEN '.0'
		ELSE '.'
		END + CAST(DATEPART(ww, r.date_) AS VARCHAR(2)) AS year_week
	,CAST(YEAR(r.date_) AS VARCHAR(4)) + CASE 
		WHEN MONTH(r.date_) < 10
			THEN '.0'
		ELSE '.'
		END + CAST(MONTH(r.date_) AS VARCHAR(2)) AS year_month
	,CAST(YEAR(r.date_) AS VARCHAR(4)) + '.' + CAST(DATEPART(qq, r.date_) AS VARCHAR(1)) + ' ��.' AS year_quarter
	,CAST(YEAR(r.date_) AS VARCHAR(4)) + '.' + CAST(DATEPART(qq, r.date_) AS VARCHAR(1)) + ' quarter' AS year_quarter_en
	,CAST(YEAR(r.date_) AS VARCHAR(4)) + CASE 
		WHEN DATEPART(mm, r.date_) > 6
			THEN '.2 �\�.'
		ELSE '.1 �\�.'
		END AS year_semester
	,YEAR(r.date_) AS year_
	,CASE 
		WHEN YEAR(r.date_) BETWEEN 2000
				AND 2099
			THEN 'XXI'
		WHEN YEAR(r.date_) BETWEEN 1900
				AND 1999
			THEN 'XX'
		WHEN YEAR(r.date_) BETWEEN 2100
				AND 2199
			THEN 'XXII'
		WHEN YEAR(r.date_) BETWEEN 1800
				AND 1899
			THEN 'XIX'
		END AS century
	,CASE 
		WHEN DATEPART(mm, r.date_) > 6
			THEN 2
		ELSE 1
		END AS semester
	,DATEPART(qq, r.date_) AS quarter_
	,MONTH(r.date_) AS month_
	,DATENAME(mm, r.date_) AS month_name
	,CASE MONTH(r.date_)
		WHEN 1
			THEN 'January'
		WHEN 2
			THEN 'February'
		WHEN 3
			THEN 'March'
		WHEN 4
			THEN 'April'
		WHEN 5
			THEN 'May'
		WHEN 6
			THEN 'June'
		WHEN 7
			THEN 'July'
		WHEN 8
			THEN 'August'
		WHEN 9
			THEN 'September'
		WHEN 10
			THEN 'October'
		WHEN 11
			THEN 'November'
		WHEN 12
			THEN 'December'
		END AS month_name_en
	,CASE MONTH(r.date_)
		WHEN 1
			THEN 'ѳ����'
		WHEN 2
			THEN '�����'
		WHEN 3
			THEN '��������'
		WHEN 4
			THEN '������'
		WHEN 5
			THEN '�������'
		WHEN 6
			THEN '�������'
		WHEN 7
			THEN '������'
		WHEN 8
			THEN '�������'
		WHEN 9
			THEN '��������'
		WHEN 10
			THEN '�������'
		WHEN 11
			THEN '��������'
		WHEN 12
			THEN '�������'
		END AS month_name_ua
	,CASE MONTH(r.date_)
		WHEN 1
			THEN '��������'
		WHEN 2
			THEN '����'
		WHEN 3
			THEN '������'
		WHEN 4
			THEN '�������'
		WHEN 5
			THEN '�������'
		WHEN 6
			THEN '�������'
		WHEN 7
			THEN '˳����'
		WHEN 8
			THEN '������'
		WHEN 9
			THEN '��������'
		WHEN 10
			THEN '���������'
		WHEN 11
			THEN '˳������'
		WHEN 12
			THEN '�������'
		END AS month_name_by
	,CASE MONTH(r.date_)
		WHEN 1
			THEN '���'
		WHEN 2
			THEN '���'
		WHEN 3
			THEN '���'
		WHEN 4
			THEN '���'
		WHEN 5
			THEN '���'
		WHEN 6
			THEN '���'
		WHEN 7
			THEN '���'
		WHEN 8
			THEN '���'
		WHEN 9
			THEN '���'
		WHEN 10
			THEN '���'
		WHEN 11
			THEN '���'
		WHEN 12
			THEN '���'
		END AS month_name_short
	,CASE MONTH(r.date_)
		WHEN 1
			THEN 'Jan'
		WHEN 2
			THEN 'Feb'
		WHEN 3
			THEN 'Mar'
		WHEN 4
			THEN 'Apr'
		WHEN 5
			THEN 'May'
		WHEN 6
			THEN 'Jun'
		WHEN 7
			THEN 'Jul'
		WHEN 8
			THEN 'Aug'
		WHEN 9
			THEN 'Sep'
		WHEN 10
			THEN 'Oct'
		WHEN 11
			THEN 'Nov'
		WHEN 12
			THEN 'Dec'
		END AS month_name_short_en
	,CASE 
		WHEN MONTH(r.date_) IN (
				9
				,10
				,11
				)
			THEN '�����'
		WHEN MONTH(r.date_) IN (
				6
				,7
				,8
				)
			THEN '����'
		WHEN MONTH(r.date_) IN (
				3
				,4
				,5
				)
			THEN '�����'
		WHEN MONTH(r.date_) IN (
				12
				,1
				,2
				)
			THEN '����'
		END AS season
	,CASE 
		WHEN MONTH(r.date_) IN (
				9
				,10
				,11
				)
			THEN 'autumn'
		WHEN MONTH(r.date_) IN (
				6
				,7
				,8
				)
			THEN 'summer'
		WHEN MONTH(r.date_) IN (
				3
				,4
				,5
				)
			THEN 'spring'
		WHEN MONTH(r.date_) IN (
				12
				,1
				,2
				)
			THEN 'winter'
		END AS season_en
	,CASE 
		WHEN MONTH(r.date_) IN (
				9
				,10
				,11
				)
			THEN '����'
		WHEN MONTH(r.date_) IN (
				6
				,7
				,8
				)
			THEN '���'
		WHEN MONTH(r.date_) IN (
				3
				,4
				,5
				)
			THEN '�����'
		WHEN MONTH(r.date_) IN (
				12
				,1
				,2
				)
			THEN '����'
		END AS season_ua
	,CASE 
		WHEN MONTH(r.date_) IN (
				9
				,10
				,11
				)
			THEN '������'
		WHEN MONTH(r.date_) IN (
				6
				,7
				,8
				)
			THEN '����'
		WHEN MONTH(r.date_) IN (
				3
				,4
				,5
				)
			THEN '�����'
		WHEN MONTH(r.date_) IN (
				12
				,1
				,2
				)
			THEN '���'
		END AS season_by
	,DATEPART(dd, r.date_) AS day_
	,DATEPART(dy, r.date_) AS year_day
	,CONVERT(VARCHAR(10), r.date_, 104) AS date_str
	,DATEPART(dw, r.date_) AS week_day
	,DATENAME(dw, r.date_) AS week_day_str
	,CASE DATEPART(dw, r.date_)
		WHEN 1
			THEN 'Monday'
		WHEN 2
			THEN 'Tuesday'
		WHEN 3
			THEN 'Wednesday'
		WHEN 4
			THEN 'Thursday'
		WHEN 5
			THEN 'Friday'
		WHEN 6
			THEN 'Saturday'
		WHEN 7
			THEN 'Sunday'
		END AS week_day_str_en
	,CASE DATEPART(dw, r.date_)
		WHEN 1
			THEN '��������'
		WHEN 2
			THEN '�������'
		WHEN 3
			THEN '������'
		WHEN 4
			THEN '������'
		WHEN 5
			THEN '�������'
		WHEN 6
			THEN '������'
		WHEN 7
			THEN '�����'
		END AS week_day_str_ua
	,CASE DATEPART(dw, r.date_)
		WHEN 1
			THEN '����������'
		WHEN 2
			THEN '������'
		WHEN 3
			THEN '������'
		WHEN 4
			THEN '������'
		WHEN 5
			THEN '������'
		WHEN 6
			THEN '������'
		WHEN 7
			THEN '�������'
		END AS week_day_str_by
	,CASE DATEPART(dw, r.date_)
		WHEN 1
			THEN '��'
		WHEN 2
			THEN '��'
		WHEN 3
			THEN '��'
		WHEN 4
			THEN '��'
		WHEN 5
			THEN '��'
		WHEN 6
			THEN '��'
		WHEN 7
			THEN '��'
		END AS week_day_short
	,CASE DATEPART(dw, r.date_)
		WHEN '1'
			THEN 'Mo'
		WHEN '2'
			THEN 'Tu'
		WHEN '3'
			THEN 'We'
		WHEN '4'
			THEN 'Th'
		WHEN '5'
			THEN 'Fr'
		WHEN '6'
			THEN 'Sa'
		WHEN '7'
			THEN 'Su'
		END AS week_day_short_en
	,DATEPART(ww, r.date_) AS week_
	,CASE 
		WHEN DAY(r.date_) < 8
			THEN 1
		WHEN DAY(r.date_) BETWEEN 8
				AND 14
			THEN 2
		WHEN DAY(r.date_) BETWEEN 5
				AND 21
			THEN 3
		WHEN DAY(r.date_) BETWEEN 22
				AND 28
			THEN 4
		WHEN DAY(r.date_) > 28
			THEN 5
		END AS month_week
	,CASE 
		WHEN DAY(r.date_) < 11
			THEN 1
		WHEN DAY(r.date_) BETWEEN 11
				AND 20
			THEN 2
		WHEN DAY(r.date_) > 20
			THEN 3
		END AS month_decade
	,CASE 
		WHEN DAY(r.date_) = DAY(DATEADD(dd, - 1, DATEADD(mm, 1, CAST(YEAR(r.date_) AS VARCHAR(4)) + CASE 
							WHEN MONTH(r.date_) < 10
								THEN '0'
							ELSE ''
							END + CAST(MONTH(r.date_) AS VARCHAR(2)) + '01')))
			THEN '��'
		ELSE ''
		END AS month_last_day
	,CASE 
		WHEN DAY(r.date_) = 31
			AND MONTH(r.date_) = 12
			THEN '��'
		ELSE ''
		END AS year_last_day
	,DAY(DATEADD(dd, - 1, DATEADD(mm, 1, CAST(YEAR(r.date_) AS VARCHAR(4)) + CASE 
					WHEN MONTH(r.date_) < 10
						THEN '0'
					ELSE ''
					END + CAST(MONTH(r.date_) AS VARCHAR(2)) + '01'))) AS days_in_month
	,CASE 
		WHEN YEAR(r.date_) IN (
				1700
				,1800
				,1900
				,2100
				,2200
				,2300
				)
			THEN 365
		ELSE DATEDIFF(dd, CAST(YEAR(r.date_) AS VARCHAR(4)) + '0101', CAST(YEAR(r.date_) AS VARCHAR(4)) + '1231') + 1
		END AS days_in_year
	,CASE 
		WHEN DATEPART(dw, r.date_) IN (
				6
				,7
				)
			THEN 1
		ELSE 0
		END AS weekend
	,CASE 
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040321'
				AND '18040420'
			THEN '01 ����'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040421'
				AND '18040520'
			THEN '02 �����'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040521'
				AND '18040621'
			THEN '03 ��������'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040622'
				AND '18040722'
			THEN '04 ���'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040723'
				AND '18040823'
			THEN '05 ���'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040824'
				AND '18040923'
			THEN '06 ����'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040924'
				AND '18041023'
			THEN '07 ����'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18041024'
				AND '18041122'
			THEN '08 ��������'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18041123'
				AND '18041221'
			THEN '09 �������'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18041222'
				AND '18041231'
			THEN '10 �������'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040101'
				AND '18040120'
			THEN '10 �������'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040121'
				AND '18040220'
			THEN '11 �������'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040221'
				AND '18040320'
			THEN '12 ����'
		END AS zodiac_sign
	,CASE 
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040321'
				AND '18040420'
			THEN '01 Aries'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040421'
				AND '18040520'
			THEN '02 Taurus'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040521'
				AND '18040621'
			THEN '03 Gemini'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040622'
				AND '18040722'
			THEN '04 Cancer'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040723'
				AND '18040823'
			THEN '05 Leo'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040824'
				AND '18040923'
			THEN '06 Virgo'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040924'
				AND '18041023'
			THEN '07 Libra'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18041024'
				AND '18041122'
			THEN '08 Scorpio'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18041123'
				AND '18041221'
			THEN '09 Sagittarius'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18041222'
				AND '18041231'
			THEN '10 Capricorn'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040101'
				AND '18040120'
			THEN '10 Capricorn'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040121'
				AND '18040220'
			THEN '11 Aquarius'
		WHEN CAST('1804' + SUBSTRING(CONVERT(VARCHAR(10), r.date_, 112), 5, 4) AS DATE) BETWEEN '18040221'
				AND '18040320'
			THEN '12 Pisces'
		END AS zodiac_sign_lat
	,CASE 
		WHEN YEAR(r.date_) = 1800
			THEN '09 ��������'
		WHEN YEAR(r.date_) = 1801
			THEN '10 �����'
		WHEN YEAR(r.date_) = 1802
			THEN '11 ������'
		WHEN YEAR(r.date_) = 1803
			THEN '12 ������'
		ELSE CASE (YEAR(r.date_) - 1804) - ((YEAR(r.date_) - 1804) / 12) * 12 + 1
				WHEN 1
					THEN '01 �����'
				WHEN 2
					THEN '02 ���'
				WHEN 3
					THEN '03 ����'
				WHEN 4
					THEN '04 ������'
				WHEN 5
					THEN '05 ������'
				WHEN 6
					THEN '06 ����'
				WHEN 7
					THEN '07 ������'
				WHEN 8
					THEN '08 ����'
				WHEN 9
					THEN '09 ��������'
				WHEN 10
					THEN '10 �����'
				WHEN 11
					THEN '11 ������'
				WHEN 12
					THEN '12 ������'
				END
		END AS chinese_horoscope
	,CASE 
		WHEN DAY(r.date_) < 10
			THEN '0'
		ELSE ''
		END + CAST(DAY(r.date_) AS VARCHAR(2)) + ' ' + CASE MONTH(r.date_)
		WHEN 1
			THEN '������'
		WHEN 2
			THEN '�������'
		WHEN 3
			THEN '�����'
		WHEN 4
			THEN '������'
		WHEN 5
			THEN '���'
		WHEN 6
			THEN '����'
		WHEN 7
			THEN '����'
		WHEN 8
			THEN '�������'
		WHEN 9
			THEN '��������'
		WHEN 10
			THEN '�������'
		WHEN 11
			THEN '������'
		WHEN 12
			THEN '�������'
		END + ' ' + CAST(YEAR(r.date_) AS VARCHAR(4)) + '�.' AS date_full_str
	,CASE MONTH(r.date_)
		WHEN 1
			THEN 'January'
		WHEN 2
			THEN 'February'
		WHEN 3
			THEN 'March'
		WHEN 4
			THEN 'April'
		WHEN 5
			THEN 'May'
		WHEN 6
			THEN 'June'
		WHEN 7
			THEN 'July'
		WHEN 8
			THEN 'August'
		WHEN 9
			THEN 'September'
		WHEN 10
			THEN 'October'
		WHEN 11
			THEN 'November'
		WHEN 12
			THEN 'December'
		END + CASE 
		WHEN DAY(r.date_) < 10
			THEN ' 0'
		ELSE ' '
		END + CAST(DAY(r.date_) AS VARCHAR(2)) + ' ' + CAST(YEAR(r.date_) AS VARCHAR(4)) AS date_full_str_en,
		
		DATENAME(WEEKDAY, DATEADD(DAY, 1 - DATEPART(DAY, r.date_), r.date_)) [FirstDayOfMonth],
        DATENAME(WEEKDAY, DATEADD(DAY, - DATEPART(DAY, DATEADD(MONTH, 1, r.date_)), DATEADD(MONTH, 1, r.date_))) [LastDayOfMonth]
FROM (
	SELECT DATEADD(hour, num*2, @d_start) AS date_
	FROM (
		SELECT z * 100000 + r * 10000 + a * 1000 + b * 100 + c * 10 + d num
		FROM (
			SELECT 0 z
			
			UNION
			
			SELECT 1
			
			UNION
			
			SELECT 2
			
			UNION
			
			SELECT 3
			
			UNION
			
			SELECT 4
			
			UNION
			
			SELECT 5
			
			UNION
			
			SELECT 6
			
			UNION
			
			SELECT 7
			
			UNION
			
			SELECT 8
			
			UNION
			
			SELECT 9
			) z
		CROSS JOIN (
			SELECT 0 r
			
			UNION
			
			SELECT 1
			
			UNION
			
			SELECT 2
			
			UNION
			
			SELECT 3
			
			UNION
			
			SELECT 4
			
			UNION
			
			SELECT 5
			
			UNION
			
			SELECT 6
			
			UNION
			
			SELECT 7
			
			UNION
			
			SELECT 8
			
			UNION
			
			SELECT 9
			) r
		CROSS JOIN (
			SELECT 0 a
			
			UNION
			
			SELECT 1
			
			UNION
			
			SELECT 2
			
			UNION
			
			SELECT 3
			
			UNION
			
			SELECT 4
			
			UNION
			
			SELECT 5
			
			UNION
			
			SELECT 6
			
			UNION
			
			SELECT 7
			
			UNION
			
			SELECT 8
			
			UNION
			
			SELECT 9
			) a
		CROSS JOIN (
			SELECT 0 b
			
			UNION
			
			SELECT 1
			
			UNION
			
			SELECT 2
			
			UNION
			
			SELECT 3
			
			UNION
			
			SELECT 4
			
			UNION
			
			SELECT 5
			
			UNION
			
			SELECT 6
			
			UNION
			
			SELECT 7
			
			UNION
			
			SELECT 8
			
			UNION
			
			SELECT 9
			) b
		CROSS JOIN (
			SELECT 0 c
			
			UNION
			
			SELECT 1
			
			UNION
			
			SELECT 2
			
			UNION
			
			SELECT 3
			
			UNION
			
			SELECT 4
			
			UNION
			
			SELECT 5
			
			UNION
			
			SELECT 6
			
			UNION
			
			SELECT 7
			
			UNION
			
			SELECT 8
			
			UNION
			
			SELECT 9
			) c
		CROSS JOIN (
			SELECT 0 d
			
			UNION
			
			SELECT 1
			
			UNION
			
			SELECT 2
			
			UNION
			
			SELECT 3
			
			UNION
			
			SELECT 4
			
			UNION
			
			SELECT 5
			
			UNION
			
			SELECT 6
			
			UNION
			
			SELECT 7
			
			UNION
			
			SELECT 8
			
			UNION
			
			SELECT 9
			) d
		) a
	WHERE DATEADD(day, num, @d_start) <= @d_end
	) r
ORDER BY 1
