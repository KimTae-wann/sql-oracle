-- 1. 100번 사원의 모든 부하직원을 계층조회한다. 106
 SELECT LEVEL - 1 AS EMP_LEVEL
 			, LPAD(' ', 4 * (LEVEL - 2)) || FIRST_NAME AS EMP_NAME
 			, EMPLOYEE_ID
			, LAST_NAME
			, MANAGER_ID
	 FROM EMPLOYEES
	WHERE LEVEL > 1
  START WITH EMPLOYEE_ID = 100
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
;

-- 2. 113번 사원의 모든 상사를 계층조회한다. 3
 SELECT LEVEL - 1 AS EMP_LEVEL 
 			, LPAD(' ', 4 * (LEVEL - 2)) || FIRST_NAME AS EMP_NAME
 			, EMPLOYEE_ID
 			, LAST_NAME
 			, MANAGER_ID
 	 FROM EMPLOYEES
 	WHERE LEVEL > 1
 	START WITH EMPLOYEE_ID = 113
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID
;

-- 3. IT 부서장의 모든 부하직원을 계층조회한다. 4
 SELECT LEVEL - 1 AS EMP_LEVEL
 			, LPAD(' ', 4 * (LEVEL - 2)) || FIRST_NAME AS EMP_NAME
 			, EMPLOYEE_ID
			, LAST_NAME
			, MANAGER_ID
	 FROM EMPLOYEES
  WHERE LEVEL > 1
  START WITH EMPLOYEE_ID = (SELECT MANAGER_ID
  													  FROM DEPARTMENTS
													   WHERE DEPARTMENT_NAME = 'IT')
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID 													  
;

-- 4. 부서장들의 부하직원을 계층조회한다. 147
 SELECT LEVEL AS EMP_LEVEL
 			, LPAD(' ', 4 * (LEVEL - 1)) || FIRST_NAME AS EMP_NAME
 			, EMPLOYEE_ID
			, LAST_NAME
			, MANAGER_ID
	 FROM EMPLOYEES
	START WITH EMPLOYEE_ID IN (SELECT DISTINCT MANAGER_ID
															 					FROM DEPARTMENTS
																			 WHERE MANAGER_ID IS NOT NULL)
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
;

-- 5. 부서명이 가장 긴 부서에서 근무중인 사원의 모든 정보를 조회한다. 0
SELECT e.EMPLOYEE_ID
     , e.FIRST_NAME
     , e.LAST_NAME
     , e.EMAIL
     , e.PHONE_NUMBER
     , e.HIRE_DATE
     , e.JOB_ID
     , e.SALARY
     , e.COMMISSION_PCT
     , e.MANAGER_ID
     , e.DEPARTMENT_ID
	FROM EMPLOYEES e
 WHERE e.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
 														FROM (SELECT DEPARTMENT_ID
																		FROM DEPARTMENTS
																	 ORDER BY LENGTH(DEPARTMENT_NAME) DESC)
												 	 WHERE ROWNUM = 1)
;

-- 6. 2002년부터 2006년까지 입사한 사원은 몇 명인지 연도별로 조회한다. 5
SELECT HIRE_YEAR
		 , COUNT(HIRE_YEAR) AS CNT_YEAR
	FROM (SELECT FIRST_NAME
						 , LAST_NAME
						 , TO_CHAR(HIRE_DATE, 'YYYY') AS HIRE_YEAR
  				FROM EMPLOYEES
  			 WHERE TO_CHAR(HIRE_DATE, 'YYYY') BETWEEN 2002
  			 										 									AND 2006)
 GROUP BY HIRE_YEAR
 ORDER BY HIRE_YEAR
;

-- 7. 입사일이 가장 빠른 사원 5명의 이름과 입사일을 조회한다. 5
SELECT FIRST_NAME
		 , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
	FROM (SELECT FIRST_NAME
						 , HIRE_DATE
					FROM EMPLOYEES
				 ORDER BY HIRE_DATE ASC)
 WHERE ROWNUM <= 5
;

-- 8. 커미션을 받는 사원들의 이름과 커미션을 조회한다. 단, 커미션이 가장 높은 사원 3명은 제외한다. 32 OR 31
SELECT FIRST_NAME
		 , COMMISSION_PCT
	FROM (SELECT FIRST_NAME
						 , COMMISSION_PCT
						 , ROWNUM AS rm
					FROM (SELECT FIRST_NAME
										 , COMMISSION_PCT
									FROM EMPLOYEES 
								 WHERE COMMISSION_PCT IS NOT NULL
								 ORDER BY COMMISSION_PCT DESC))
 WHERE rm > 3
;

SELECT FIRST_NAME
		 , COMMISSION_PCT
	FROM (SELECT FIRST_NAME
						 , COMMISSION_PCT
						 , RANK() OVER (ORDER BY COMMISSION_PCT DESC) AS rnk
					FROM EMPLOYEES
				 WHERE COMMISSION_PCT IS NOT NULL)
 WHERE rnk > 3
;	

-- 결과
/*
1번

1	Neena	101	Kochhar	100
2	    Nancy	108	Greenberg	101
3	        Daniel	109	Faviet	108
3	        John	110	Chen	108
3	        Ismael	111	Sciarra	108
3	        Jose Manuel	112	Urman	108
3	        Luis	113	Popp	108
2	    Jennifer	200	Whalen	101
2	    Susan	203	Mavris	101
2	    Hermann	204	Baer	101
2	    Shelley	205	Higgins	101
3	        William	206	Gietz	205
1	Lex	102	De Haan	100
2	    Alexander	103	Hunold	102
3	        Bruce	104	Ernst	103
3	        David	105	Austin	103
3	        Valli	106	Pataballa	103
3	        Diana	107	Lorentz	103
1	Den	114	Raphaely	100
2	    Alexander	115	Khoo	114
2	    Shelli	116	Baida	114
2	    Sigal	117	Tobias	114
2	    Guy	118	Himuro	114
2	    Karen	119	Colmenares	114
1	Matthew	120	Weiss	100
2	    Julia	125	Nayer	120
2	    Irene	126	Mikkilineni	120
2	    James	127	Landry	120
2	    Steven	128	Markle	120
2	    Winston	180	Taylor	120
2	    Jean	181	Fleaur	120
2	    Martha	182	Sullivan	120
2	    Girard	183	Geoni	120
1	Adam	121	Fripp	100
2	    Laura	129	Bissot	121
2	    Mozhe	130	Atkinson	121
2	    James	131	Marlow	121
2	    TJ	132	Olson	121
2	    Nandita	184	Sarchand	121
2	    Alexis	185	Bull	121
2	    Julia	186	Dellinger	121
2	    Anthony	187	Cabrio	121
1	Payam	122	Kaufling	100
2	    Jason	133	Mallin	122
2	    Michael	134	Rogers	122
2	    Ki	135	Gee	122
2	    Hazel	136	Philtanker	122
2	    Kelly	188	Chung	122
2	    Jennifer	189	Dilly	122
2	    Timothy	190	Gates	122
2	    Randall	191	Perkins	122
1	Shanta	123	Vollman	100
2	    Renske	137	Ladwig	123
2	    Stephen	138	Stiles	123
2	    John	139	Seo	123
2	    Joshua	140	Patel	123
2	    Sarah	192	Bell	123
2	    Britney	193	Everett	123
2	    Samuel	194	McCain	123
2	    Vance	195	Jones	123
1	Kevin	124	Mourgos	100
2	    Trenna	141	Rajs	124
2	    Curtis	142	Davies	124
2	    Randall	143	Matos	124
2	    Peter	144	Vargas	124
2	    Alana	196	Walsh	124
2	    Kevin	197	Feeney	124
2	    Donald	198	OConnell	124
2	    Douglas	199	Grant	124
1	John	145	Russell	100
2	    Peter	150	Tucker	145
2	    David	151	Bernstein	145
2	    Peter	152	Hall	145
2	    Christopher	153	Olsen	145
2	    Nanette	154	Cambrault	145
2	    Oliver	155	Tuvault	145
1	Karen	146	Partners	100
2	    Janette	156	King	146
2	    Patrick	157	Sully	146
2	    Allan	158	McEwen	146
2	    Lindsey	159	Smith	146
2	    Louise	160	Doran	146
2	    Sarath	161	Sewall	146
1	Alberto	147	Errazuriz	100
2	    Clara	162	Vishney	147
2	    Danielle	163	Greene	147
2	    Mattea	164	Marvins	147
2	    David	165	Lee	147
2	    Sundar	166	Ande	147
2	    Amit	167	Banda	147
1	Gerald	148	Cambrault	100
2	    Lisa	168	Ozer	148
2	    Harrison	169	Bloom	148
2	    Tayler	170	Fox	148
2	    William	171	Smith	148
2	    Elizabeth	172	Bates	148
2	    Sundita	173	Kumar	148
1	Eleni	149	Zlotkey	100
2	    Ellen	174	Abel	149
2	    Alyssa	175	Hutton	149
2	    Jonathon	176	Taylor	149
2	    Jack	177	Livingston	149
2	    Kimberely	178	Grant	149
2	    Charles	179	Johnson	149
1	Michael	201	Hartstein	100
2	    Pat	202	Fay	201  

2번

1	Nancy	108	Greenberg	101
2	    Neena	101	Kochhar	100
3	        Steven	100	King	

3번

1	Bruce	104	Ernst	103
1	David	105	Austin	103
1	Valli	106	Pataballa	103
1	Diana	107	Lorentz	103

4번

1	Den	114	Raphaely	100
2	    Alexander	115	Khoo	114
2	    Shelli	116	Baida	114
2	    Sigal	117	Tobias	114
2	    Guy	118	Himuro	114
2	    Karen	119	Colmenares	114
1	Adam	121	Fripp	100
2	    Laura	129	Bissot	121
2	    Mozhe	130	Atkinson	121
2	    James	131	Marlow	121
2	    TJ	132	Olson	121
2	    Nandita	184	Sarchand	121
2	    Alexis	185	Bull	121
2	    Julia	186	Dellinger	121
2	    Anthony	187	Cabrio	121
1	John	145	Russell	100
2	    Peter	150	Tucker	145
2	    David	151	Bernstein	145
2	    Peter	152	Hall	145
2	    Christopher	153	Olsen	145
2	    Nanette	154	Cambrault	145
2	    Oliver	155	Tuvault	145
1	Michael	201	Hartstein	100
2	    Pat	202	Fay	201
1	Nancy	108	Greenberg	101
2	    Daniel	109	Faviet	108
2	    John	110	Chen	108
2	    Ismael	111	Sciarra	108
2	    Jose Manuel	112	Urman	108
2	    Luis	113	Popp	108
1	Jennifer	200	Whalen	101
1	Susan	203	Mavris	101
1	Hermann	204	Baer	101
1	Shelley	205	Higgins	101
2	    William	206	Gietz	205
1	Alexander	103	Hunold	102
2	    Bruce	104	Ernst	103
2	    David	105	Austin	103
2	    Valli	106	Pataballa	103
2	    Diana	107	Lorentz	103
1	Steven	100	King	
2	    Neena	101	Kochhar	100
3	        Nancy	108	Greenberg	101
4	            Daniel	109	Faviet	108
4	            John	110	Chen	108
4	            Ismael	111	Sciarra	108
4	            Jose Manuel	112	Urman	108
4	            Luis	113	Popp	108
3	        Jennifer	200	Whalen	101
3	        Susan	203	Mavris	101
3	        Hermann	204	Baer	101
3	        Shelley	205	Higgins	101
4	            William	206	Gietz	205
2	    Lex	102	De Haan	100
3	        Alexander	103	Hunold	102
4	            Bruce	104	Ernst	103
4	            David	105	Austin	103
4	            Valli	106	Pataballa	103
4	            Diana	107	Lorentz	103
2	    Den	114	Raphaely	100
3	        Alexander	115	Khoo	114
3	        Shelli	116	Baida	114
3	        Sigal	117	Tobias	114
3	        Guy	118	Himuro	114
3	        Karen	119	Colmenares	114
2	    Matthew	120	Weiss	100
3	        Julia	125	Nayer	120
3	        Irene	126	Mikkilineni	120
3	        James	127	Landry	120
3	        Steven	128	Markle	120
3	        Winston	180	Taylor	120
3	        Jean	181	Fleaur	120
3	        Martha	182	Sullivan	120
3	        Girard	183	Geoni	120
2	    Adam	121	Fripp	100
3	        Laura	129	Bissot	121
3	        Mozhe	130	Atkinson	121
3	        James	131	Marlow	121
3	        TJ	132	Olson	121
3	        Nandita	184	Sarchand	121
3	        Alexis	185	Bull	121
3	        Julia	186	Dellinger	121
3	        Anthony	187	Cabrio	121
2	    Payam	122	Kaufling	100
3	        Jason	133	Mallin	122
3	        Michael	134	Rogers	122
3	        Ki	135	Gee	122
3	        Hazel	136	Philtanker	122
3	        Kelly	188	Chung	122
3	        Jennifer	189	Dilly	122
3	        Timothy	190	Gates	122
3	        Randall	191	Perkins	122
2	    Shanta	123	Vollman	100
3	        Renske	137	Ladwig	123
3	        Stephen	138	Stiles	123
3	        John	139	Seo	123
3	        Joshua	140	Patel	123
3	        Sarah	192	Bell	123
3	        Britney	193	Everett	123
3	        Samuel	194	McCain	123
3	        Vance	195	Jones	123
2	    Kevin	124	Mourgos	100
3	        Trenna	141	Rajs	124
3	        Curtis	142	Davies	124
3	        Randall	143	Matos	124
3	        Peter	144	Vargas	124
3	        Alana	196	Walsh	124
3	        Kevin	197	Feeney	124
3	        Donald	198	OConnell	124
3	        Douglas	199	Grant	124
2	    John	145	Russell	100
3	        Peter	150	Tucker	145
3	        David	151	Bernstein	145
3	        Peter	152	Hall	145
3	        Christopher	153	Olsen	145
3	        Nanette	154	Cambrault	145
3	        Oliver	155	Tuvault	145
2	    Karen	146	Partners	100
3	        Janette	156	King	146
3	        Patrick	157	Sully	146
3	        Allan	158	McEwen	146
3	        Lindsey	159	Smith	146
3	        Louise	160	Doran	146
3	        Sarath	161	Sewall	146
2	    Alberto	147	Errazuriz	100
3	        Clara	162	Vishney	147
3	        Danielle	163	Greene	147
3	        Mattea	164	Marvins	147
3	        David	165	Lee	147
3	        Sundar	166	Ande	147
3	        Amit	167	Banda	147
2	    Gerald	148	Cambrault	100
3	        Lisa	168	Ozer	148
3	        Harrison	169	Bloom	148
3	        Tayler	170	Fox	148
3	        William	171	Smith	148
3	        Elizabeth	172	Bates	148
3	        Sundita	173	Kumar	148
2	    Eleni	149	Zlotkey	100
3	        Ellen	174	Abel	149
3	        Alyssa	175	Hutton	149
3	        Jonathon	176	Taylor	149
3	        Jack	177	Livingston	149
3	        Kimberely	178	Grant	149
3	        Charles	179	Johnson	149
2	    Michael	201	Hartstein	100
3	        Pat	202	Fay	201

5번

6번

2002	7
2003	6
2004	10
2005	29
2006	24

7번

Lex	2001-01-13
Susan	2002-06-07
William	2002-06-07
Shelley	2002-06-07
Hermann	2002-06-07

8번

Janette	0.35
Louise	0.3
Lindsey	0.3
Karen	0.3
Ellen	0.3
Gerald	0.3
Alberto	0.3
Peter	0.3
Peter	0.25
David	0.25
Clara	0.25
Alyssa	0.25
Lisa	0.25
Sarath	0.25
Tayler	0.2
Nanette	0.2
Christopher	0.2
Jonathon	0.2
Eleni	0.2
Harrison	0.2
Jack	0.2
Danielle	0.15
Kimberely	0.15
Elizabeth	0.15
William	0.15
Oliver	0.15
Mattea	0.1
David	0.1
Sundar	0.1
Charles	0.1
Sundita	0.1
Amit	0.1

*/

