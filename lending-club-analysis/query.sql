-- Lending Club Advanced SQL Analysis
SELECT 
    grade,
    sub_grade,
    COUNT(id) AS total_loans,
    AVG(loan_amnt) AS avg_loan_amount,
    AVG(int_rate) AS avg_interest_rate,
    SUM(CASE WHEN loan_status IN ('Charged Off', 'Default', 'Late (31-120 days)') THEN 1 ELSE 0 END) * 100.0 / COUNT(id) AS default_rate_pct
FROM loan
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;
