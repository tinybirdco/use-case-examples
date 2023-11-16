# Tinybird Versions - Change column from String to LowCardinality(String)

This update involves several changes aimed at optimizing the storage and query performance of the `analytics_pages_mv` datasource. The primary change is the conversion of the `browser` column from a `String` type to a `LowCardinality(String)` type. 

## Detailed Changes

1. **`.tinyenv`**: The `VERSION` was updated from `0.0.0` to `0.0.1`. As we are going to release a new version

2. **`analytics_pages_mv.datasource`**: This file was renamed to `analytics_pages_mv_v1.datasource` as we wanted to create a new version of the resource, and the `browser` column type was changed from `String` to `LowCardinality(String)`.

4. **`deploy/0.0.1/cd-deploy.sh` and `deploy/0.0.1/ci-deploy.sh`**: These new deployment scripts were added. They include commands to deploy the changes and populate the new datasource with backfilled data using the script `populate_with_backfill` inside the `utils` folder

5. **`analytics_pages.pipe`**: This file was renamed to `analytics_pages_v1.pipe` as we wanted to create a new version of the resource, and the SQL query was updated to cast the `browser` column to `LowCardinality`.
