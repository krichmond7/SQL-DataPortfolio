### 1. What is the attrition rate by Education level?
```sql
SELECT
    Education,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY Education
ORDER BY Education;
```

### 2. How does Environment Satisfaction relate to attrition?
```sql
SELECT
    EnvironmentSatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;
```

### 3. Do low Job Involvement scores predict higher attrition?
```sql
SELECT
    JobInvolvement,
    COUNT(*) AS total_employees,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobInvolvement
ORDER BY JobInvolvement;
```

### 4. What is the average Job Satisfaction by department, and which department is lowest?
```sql
SELECT
    Department,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction,
    COUNT(*) AS total_employees
FROM hr_attrition
GROUP BY Department
ORDER BY avg_job_satisfaction ASC;
```

### 5. Do higher Performance Ratings correlate with higher salary hikes?
```sql
SELECT
    PerformanceRating,
    COUNT(*) AS total_employees,
    ROUND(AVG(PercentSalaryHike), 2) AS avg_salary_hike_pct
FROM hr_attrition
GROUP BY PerformanceRating
ORDER BY PerformanceRating;
```

### 6. How does Relationship Satisfaction and attrition differ by gender?
```sql
SELECT
    Gender,
    RelationshipSatisfaction,
    COUNT(*) AS total_employees,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY Gender, RelationshipSatisfaction
ORDER BY Gender, RelationshipSatisfaction;
```

### 7. Does poor Work-Life Balance combined with OverTime increase attrition risk?
```sql
SELECT
    WorkLifeBalance,
    OverTime,
    COUNT(*) AS total_employees,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY WorkLifeBalance, OverTime
ORDER BY WorkLifeBalance, OverTime;
```

### 8. Which single satisfaction metric shows the widest attrition-rate spread (biggest risk indicator)?
```sql
WITH satisfaction_summary AS (
    SELECT 'EnvironmentSatisfaction' AS metric, EnvironmentSatisfaction AS score,
           100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*) AS attrition_rate
    FROM hr_attrition GROUP BY EnvironmentSatisfaction
    UNION ALL
    SELECT 'JobSatisfaction', JobSatisfaction,
           100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
    FROM hr_attrition GROUP BY JobSatisfaction
    UNION ALL
    SELECT 'RelationshipSatisfaction', RelationshipSatisfaction,
           100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
    FROM hr_attrition GROUP BY RelationshipSatisfaction
    UNION ALL
    SELECT 'WorkLifeBalance', WorkLifeBalance,
           100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
    FROM hr_attrition GROUP BY WorkLifeBalance
)
SELECT
    metric,
    ROUND(MAX(attrition_rate) - MIN(attrition_rate), 2) AS attrition_rate_spread
FROM satisfaction_summary
GROUP BY metric
ORDER BY attrition_rate_spread DESC;
```

### 9. What is the average score across all satisfaction/involvement metrics, broken out by department?
```sql
SELECT
    Department,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS avg_environment,
    ROUND(AVG(JobInvolvement), 2) AS avg_job_involvement,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(RelationshipSatisfaction), 2) AS avg_relationship,
    ROUND(AVG(WorkLifeBalance), 2) AS avg_worklife_balance
FROM hr_attrition
GROUP BY Department
ORDER BY Department;
```
### 10. Among top performers (PerformanceRating = 4), which satisfaction category is lowest — a potential flight-risk signal?
```sql
SELECT
    ROUND(AVG(EnvironmentSatisfaction), 2) AS avg_environment,
    ROUND(AVG(JobInvolvement), 2) AS avg_job_involvement,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(RelationshipSatisfaction), 2) AS avg_relationship,
    ROUND(AVG(WorkLifeBalance), 2) AS avg_worklife_balance,
    ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
WHERE PerformanceRating = 4;
```

