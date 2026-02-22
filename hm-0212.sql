-- 24. 평균 월급보다 많이 받는 사원들의 사원번호, 이름, 성, 월급을 조회한다.
SELECT e.EMPLOYEE_ID
		 , e.FIRST_NAME
		 , e.LAST_NAME
		 , e.SALARY
	FROM EMPLOYEES e
 WHERE e.SALARY > (SELECT AVG(SALARY)
 									 FROM EMPLOYEES)
;

-- 25. 평균 월급보다 적게 받는 사원들의 사원번호, 월급, 부서번호를 조회한다.
SELECT e.EMPLOYEE_ID
		 , e.SALARY
		 , e.DEPARTMENT_ID
	FROM EMPLOYEES e
 WHERE e.SALARY < (SELECT AVG(SALARY)
 										 FROM EMPLOYEES)
;

-- 26. 가장 많은 월급을 받는 사원의 사원번호, 이름, 월급을 조회한다.
SELECT e.EMPLOYEE_ID
		 , e.FIRST_NAME 
		 , e.SALARY
	FROM EMPLOYEES e
 WHERE e.SALARY = (SELECT MAX(SALARY)
 										 FROM EMPLOYEES)
;

-- 오답 / 중복이 없다는 가정하에서만 가능함
SELECT e.EMPLOYEE_ID
     , e.FIRST_NAME
     , e.SALARY
  FROM ( SELECT EMPLOYEE_ID
              , FIRST_NAME
              , SALARY
           FROM EMPLOYEES
          ORDER BY SALARY DESC) e
 WHERE ROWNUM = 1;

-- 30. 가장 늦게 입사한 사원의 모든 정보를 조회한다.
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
 WHERE e.HIRE_DATE = (SELECT MAX(HIRE_DATE)
 												FROM EMPLOYEES)
;

-- 31. 가장 일찍 입사한 사원의 모든 정보를 조회한다.
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
 WHERE e.HIRE_DATE = (SELECT MIN(HIRE_DATE)
 												FROM EMPLOYEES)
;

-- 32. 자신의 상사보다 더 많은 월급을 받는 사원의 모든 정보를 조회한다.
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
 WHERE e.SALARY > (SELECT sub1.SALARY 
 										 FROM EMPLOYEES sub1
 										WHERE sub1.EMPLOYEE_ID = e.MANAGER_ID)
;

-- 33. 자신의 상사보다 더 일찍 입사한 사원의 모든 정보를 조회한다.
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
 WHERE e.HIRE_DATE < (SELECT sub1.HIRE_DATE
 										 		FROM EMPLOYEES sub1
 											 WHERE sub1.EMPLOYEE_ID = e.MANAGER_ID)
;
-- 36. 가장 많은 인센티브를 받는 사원의 모든 정보를 조회한다.
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
 WHERE e.COMMISSION_PCT = (SELECT MAX(COMMISSION_PCT)
 										 				 FROM EMPLOYEES)
;

-- 37. 가장 적은 인센티브를 받는 사원의 월급과 인센티브를 조회한다.
SELECT e.SALARY
		 , e.COMMISSION_PCT
	FROM EMPLOYEES e
 WHERE e.COMMISSION_PCT = (SELECT MIN(COMMISSION_PCT)
 														 FROM EMPLOYEES)
;

-- 40. 사원이 속한 부서의 평균월급보다 적게 받는 사원의 모든 정보를 조회한다.
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
 WHERE e.SALARY < (SELECT AVG(SALARY)
 									 FROM EMPLOYEES
 									WHERE DEPARTMENT_ID = e.DEPARTMENT_ID);
;

SELECT e.EMPLOYEE_ID
     , e.FIRST_NAME
     , e.LAST_NAME
     , e.SALARY
	FROM EMPLOYEES e
	JOIN ( SELECT DEPARTMENT_ID
							, AVG(SALARY) AS AVG_SALARY
					 FROM EMPLOYEES
					GROUP BY DEPARTMENT_ID) d
		ON e.DEPARTMENT_ID  = d.DEPARTMENT_ID
 WHERE e.SALARY < d.AVG_SALARY
;

-- 44. 50번 부서의 부서장의 이름, 성, 월급을 조회한다.
SELECT e.FIRST_NAME
		 , e.LAST_NAME
		 , e.SALARY 
	FROM EMPLOYEES e
 WHERE e.EMPLOYEE_ID = (SELECT d.MANAGER_ID
 													FROM DEPARTMENTS d 
 												 WHERE d.DEPARTMENT_ID = 50)
;

-- 47. 사원이 없는 부서명을 조회한다.
SELECT d.DEPARTMENT_NAME
	FROM DEPARTMENTS d
 WHERE DEPARTMENT_ID NOT IN (SELECT DISTINCT e.DEPARTMENT_ID
 															 FROM EMPLOYEES e 
 															WHERE e.DEPARTMENT_ID IS NOT NULL)
;

-- 48. 직무가 변경된 사원의 모든 정보를 조회한다.
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
 WHERE e.EMPLOYEE_ID IN (SELECT DISTINCT jh.EMPLOYEE_ID
 													FROM JOB_HISTORY jh)
;

-- 49. 직무가 변경된적 없는 사원의 모든 정보를 조회한다.
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
 WHERE e.EMPLOYEE_ID NOT IN (SELECT DISTINCT jh.EMPLOYEE_ID
 													FROM JOB_HISTORY jh)
;

-- 56. 월급이 7000 에서 12000 사이인 사원이 근무중인 도시를 조회한다.
SELECT l.CITY
	FROM LOCATIONS l
 WHERE l.LOCATION_ID IN (SELECT DISTINCT d.LOCATION_ID
 													 FROM DEPARTMENTS d 
 													WHERE d.DEPARTMENT_ID IN (SELECT DISTINCT e.DEPARTMENT_ID
 																											FROM EMPLOYEES e
 																										 WHERE e.SALARY BETWEEN 7000 AND 12000))
;

-- 57. 'Seattle' 에서 근무중인 사원의 직무명을 중복없이 조회한다.
SELECT DISTINCT j.JOB_TITLE
	FROM JOBS j
 WHERE j.JOB_ID IN (SELECT DISTINCT e.JOB_ID
 											FROM EMPLOYEES e
 										 WHERE e.DEPARTMENT_ID IN (SELECT d.DEPARTMENT_ID
 										 														 FROM DEPARTMENTS d
 										 														WHERE d.LOCATION_ID IN (SELECT l.LOCATION_ID
 										 																											FROM LOCATIONS l
 										 																										 WHERE l.CITY = 'Seattle')))
;

-- 59. 이름이 'Renske' 인 사원의 월급과 같은 월급을 받는 사원의 모든 정보를 조회한다. 단, 'Renske' 사원은 조회에서 제외한다.
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
 WHERE e.SALARY IN (SELECT SALARY
									 FROM EMPLOYEES
									WHERE FIRST_NAME = 'Renske')
	 AND e.FIRST_NAME != 'Renske'
;

-- 60. 회사 전체의 평균 월급보다 많이 받는 사원들 중 이름에 'u' 가 포함된 사원과 동일한 부서에서 근무중인 사원들의 모든 정보를 조회한다.
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
 WHERE e.DEPARTMENT_ID IN (SELECT sub.DEPARTMENT_ID
														FROM EMPLOYEES sub
													 WHERE sub.SALARY > (SELECT AVG(SALARY)
													 										 	 FROM EMPLOYEES)
													 	 AND sub.FIRST_NAME LIKE '%u%')
;

-- 61. 부서가 없는 국가명을 조회한다.
SELECT c.COUNTRY_NAME
	FROM COUNTRIES c 
 WHERE c.COUNTRY_ID NOT IN (SELECT l.COUNTRY_ID
 													 		FROM LOCATIONS l
 														 WHERE l.LOCATION_ID IN (SELECT DISTINCT LOCATION_ID
 																											 FROM DEPARTMENTS
 																									 		WHERE DEPARTMENT_ID IS NOT NULL))
;

-- 62. 'Europe' 에서 근무중인 사원들의 모든 정보를 조회한다.
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
 WHERE e.DEPARTMENT_ID IN (SELECT d.DEPARTMENT_ID
 														 FROM DEPARTMENTS d
 														WHERE d.LOCATION_ID IN (SELECT l.LOCATION_ID
 																											FROM LOCATIONS l 
 																										 WHERE l.COUNTRY_ID IN (SELECT c.COUNTRY_ID
 																										 													FROM COUNTRIES c
 																										 												 WHERE c.REGION_ID IN (SELECT r.REGION_ID
 																										 												 												 FROM REGIONS r
 																										 												 												WHERE REGION_NAME = 'Europe'))))
;

-- 78. 직무별 최대월급보다 더 많은 월급을 받는 사원의 모든 정보를 조회한다.
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
 WHERE e.SALARY > (SELECT MAX(SALARY)
 										 FROM EMPLOYEES sub
 										WHERE e.JOB_ID = sub.JOB_ID)
;

-- 112. 109번 사원의 입사일로 부터 1년 동안 입사한 사원의 모든 정보를 조회한다.
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
 WHERE e.HIRE_DATE BETWEEN (SELECT HIRE_DATE
															FROM EMPLOYEES
														 WHERE EMPLOYEE_ID = 109)
											 AND ADD_MONTHS((SELECT HIRE_DATE
																				 FROM EMPLOYEES
														 						WHERE EMPLOYEE_ID = 109), 12)
;

-- 113. 가장 먼저 입사한 사원의 입사일로부터 2년 동안 입사한 사원의 모든 정보를 조회한다.
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
 WHERE e.HIRE_DATE BETWEEN (SELECT MIN(HIRE_DATE)
															FROM EMPLOYEES)
											 AND ADD_MONTHS((SELECT MIN(HIRE_DATE)
																				 FROM EMPLOYEES), 24)
;

-- 114. 가장 늦게 입사한 사원의 입사일 보다 1년 앞서 입사한 사원의 모든 정보를 조회한다.
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
 WHERE e.HIRE_DATE BETWEEN ADD_MONTHS((SELECT MAX(HIRE_DATE)
																				 FROM EMPLOYEES), -12)
											 AND (SELECT MAX(HIRE_DATE)
															FROM EMPLOYEES)
;	
 
---- 추가 문제

-- 1. 부서아이디별 사원의 평균연봉을 조회한다.
SELECT AVG(SALARY)
	FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
;

-- 2. 직무아이디별 사원의 최고연봉을 조회한다.
SELECT MAX(SALARY)
	FROM EMPLOYEES
 GROUP BY JOB_ID
;

-- 3. 인센티브를 안받는 사원의 모든 정보를 조회한다.
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
 WHERE e.COMMISSION_PCT IS NULL
;

-- 4. 인센티브를 받는 사원의 부서아이디를 중복없이 조회한다.
SELECT DISTINCT e.DEPARTMENT_ID
	FROM EMPLOYEES e
 WHERE e.COMMISSION_PCT IS NOT NULL
;

-- 5. 인센티브를 받는 사원의 직무아이디를 중복없이 조회한다.
SELECT DISTINCT e.JOB_ID
	FROM EMPLOYEES e
 WHERE e.COMMISSION_PCT IS NOT NULL
;

-- 6. 사원이 있는 부서의 지역아이디를 조회한다.
SELECT DISTINCT d.LOCATION_ID
   				 FROM DEPARTMENTS d
				  WHERE d.DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID
																							 FROM EMPLOYEES
																							WHERE EMPLOYEE_ID IS NOT NULL)
;

-- 7. Seattle에 존재하는 부서번호를 조회한다.
SELECT d.DEPARTMENT_ID
	FROM DEPARTMENTS d
 WHERE d.LOCATION_ID IN (SELECT LOCATION_ID
													 FROM LOCATIONS
													WHERE CITY = 'Seattle')
;

-- 8. 사원이 한명도 없는 도시를 조회한다.
SELECT DISTINCT l.CITY
				   FROM LOCATIONS l
				  WHERE l.LOCATION_ID NOT IN (SELECT DISTINCT d.LOCATION_ID
																								 FROM DEPARTMENTS d
																							  WHERE d.DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID
																																					 					 FROM EMPLOYEES))
;

-- 9. 사원이 한명이라도 있는 도시를 조회한다.
SELECT DISTINCT l.CITY
				   FROM LOCATIONS l
				  WHERE l.LOCATION_ID IN (SELECT DISTINCT d.LOCATION_ID
												  									 FROM DEPARTMENTS d
																					  WHERE d.DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID
																																			 					 FROM EMPLOYEES))
;

-- 10. 모든 사원의 정보를 연봉으로 오름차순 정렬하여 조회한다.
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
 ORDER BY e.SALARY ASC
;

-- 11. 모든 사원의 사원번호, 이름, 성, 연봉, 인센티브를 포함한 연봉 정보를 조회한다.
SELECT e.EMPLOYEE_ID
		 , e.FIRST_NAME
		 , e.LAST_NAME
		 , e.SALARY
		 , e.COMMISSION_PCT
	FROM EMPLOYEES e
;

-- 12. 2003년에 입사한 사원은 몇 명인지 조회한다.
SELECT COUNT(EMPLOYEE_ID)
	FROM EMPLOYEES e
 WHERE TO_CHAR(e.HIRE_DATE, 'YYYY') = 2003
;

-- 13. 113번 사원의 상사의 모든 정보를 조회한다.
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
 WHERE e.EMPLOYEE_ID = (SELECT MANAGER_ID
 												 	FROM EMPLOYEES
 												 WHERE EMPLOYEE_ID = 113)
;

-- 14. 모든 부서의 부서장의 모든 사원 정보를 조회한다.
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
 WHERE e.EMPLOYEE_ID IN (SELECT DISTINCT MANAGER_ID
 												   					FROM DEPARTMENTS)

-- 15. 사원의 이름이 7자리인 사원의 모든 정보를 조회한다.
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
 WHERE e.FIRST_NAME LIKE '_______'
;

-- 16. 사원의 이메일이 6자리인 사원의 모든 정보를 조회한다.
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
 WHERE e.EMAIL LIKE '______'
;