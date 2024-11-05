-- - **Who the thief is** 

SELECT * FROM "crime_scene_reports" 
WHERE "year" = 2023 AND "month" = 07 AND "day" = 28 AND "street" = 'Humphrey Street';


SELECT * FROM "interviews"
WHERE  "year" = 2023 AND "month" = 07 AND "day" = 28 AND "transcript" LIKE '%thief%';

DROP VIEW IF EXISTS "gathered_evidence";

CREATE VIEW "gathered_evidence" AS 
SELECT ppl."id", ppl."name",  ppl."phone_number", p."passport_number", bsl."license_plate" FROM "bakery_security_logs" bsl
INNER JOIN "people" p ON bsl."license_plate" = p."license_plate"
INNER JOIN "passengers" psn ON p."passport_number" = psn."passport_number"
INNER JOIN "people" ppl ON ppl."passport_number" = psn."passport_number"
INNER JOIN "bank_accounts" bnk ON bnk."person_id" = ppl."id"
INNER JOIN "phone_calls" call ON call."caller" = ppl."phone_number"


WHERE  bsl."year" = 2023 AND bsl."month" = 07 AND bsl."day" = 28 AND bsl."hour" = 10 AND 
bsl."minute" BETWEEN 15 AND 25 AND bsl."activity" = 'exit'

AND psn."flight_id" =(
    SELECT "id" FROM "flights"
    WHERE "origin_airport_id" = (
        SELECT "id" FROM "airports" 
        WHERE "full_name"  LIKE '%Fiftyville%'
        )
    AND "year" = 2023 AND "month" = 07 AND "day" = 29 
    ORDER BY "hour" LIMIT 1
)

AND  call."year" = 2023 AND call."month" = 07 AND call."day" = 28 AND call."duration" < 60; 

SELECT * FROM "gathered_evidence";
-- - **What city the thief escaped to**

SELECT "city" FROM "airports"
WHERE "id" = (
    SELECT "destination_airport_id" FROM "flights"
    WHERE "origin_airport_id" = (
        SELECT "id" FROM "airports" 
        WHERE "full_name"  LIKE '%Fiftyville%'
    )
    AND "year" = 2023 AND "month" = 07 AND "day" = 29 
    ORDER BY "hour" LIMIT 1
);

-- - **Who the thief’s accomplice is who helped them escape** 

SELECT * FROM "people"
WHERE "phone_number" = (
    SELECT "receiver" FROM "phone_calls"
    WHERE "caller" = (
        SELECT "phone_number" FROM "gathered_evidence"
    )
    AND "year" = 2023 AND "month" = 7 AND "day" = 28 AND "duration" < 60
);