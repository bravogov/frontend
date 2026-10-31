# United Hampshire task-based GOV.UH services

The maintained Rails source for the public service journeys commissioned on 31 October 2026 belongs in this Frontend repository.

## Implemented
- `/find-local-council` and `/find-local-council/result`: select the known Havenstead local area and service. Never infer a postcode boundary or represent a council that has not commenced as operating.
- `/when-do-the-clocks-change`: England clock-change dates calculated using the final Sundays in March and October.
- `/check-citizenship-or-immigration-service`: 12 read-only task routes and responsible Interior Office guidance. The route is not itself an application or a grant of immigration status.
- `/check-working-hours-and-breaks`: England working-time information distinguished from Havenstead public-service arrangements.
- `app/views/homepage/index.html.erb`: service shortcuts are shown without unverified “Most viewed” statistics, preserving the corrected section boundary.

The initial source migration was verified against the deployed container: all ten relevant controller/view/homepage files are byte-for-byte equal. Public route, negative-input and original browse/navigation regression tests passed (37/37 pages, 28/28 guides).

## Ownership and records
The Frontend does not store applications, make decisions, appoint public officials, or confer legal powers. The original GOV.UH Forms service and department-owned casework are separate. Content publication is owned by Publisher and browse tagging by Collections Publisher. Infrastructure release history and acceptance proof are in the private `bravogov/govuh-infrastructure` repository.

The old `OfficerEethCoth121/united-hampshire-digital-estate` repository is retired. Do not source code, releases or operations from it. Its earlier copies are historical records only.
