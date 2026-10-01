# sample-4 — PRD

## Problem Statement

A consumer who needs the average of a scored catalog today has to fetch the
catalog itself and compute the aggregate by hand, re-implementing the same sum-and-divide
logic wherever the number is needed. There is also no simple way to exercise
how an average-reporting service behaves when its upstream data source has no
data at all, which makes that condition hard to test deliberately.

## Solution

Two backend services work together: Service2 serves a catalog of scored
records and can be switched, through an internal hook, between serving its
full fixed catalog and serving no records at all. Service1 asks Service2 for
whatever catalog it currently holds and reports the average score as a whole
number, using the same computation regardless of which catalog Service2 is
serving.

## Actors

- **User**: calls Service1 to get the current average score. Access is open —
no sign-in is required. A User never reaches Service2 directly, and never
reaches Service2's internal operations endpoint.

## User Stories

1. As a User, I want to request the average score from Service1, so that I get the aggregate statistic without fetching the catalog and computing it myself.
2. As a User, I want a structured 404 response when I request a path Service1 does not serve, so that I get clear, machine-readable feedback for unsupported requests.

## Product Decisions

- Access to Service1 is open/anonymous — no sign-in or identity layer sits in front of it.
- Service2 serves a fixed catalog of 10 scored records in its full mode, reproduced verbatim in the design and seed data:
- Service2 starts in full mode. It exposes an internal operations endpoint,
never reachable by a User, that switches it between full mode and empty
mode; in empty mode it serves a catalog with no records. This endpoint is an
internal/test hook — it belongs to no product actor and is not itself a user
story.
- Service1 computes the average score as the sum of every record's score
divided by the number of records, discarding any remainder (integer
division). Against the full catalog this average is 35.
- The same computation path runs for every catalog Service2 can serve — there
is no separate path, and no separate result, carved out for any particular
catalog.
- Both Service1 and Service2 log how many records they handled per request.
- Service1's OpenAPI contract documents exactly one response for its average
endpoint: the successful average. It documents no 4xx or 5xx response on
that endpoint, regardless of cause.
- A request to a path Service1 does not serve returns a structured 404 body.
This is the only documented error case, and it applies only to unsupported
paths — not to the average endpoint itself.

## Out of Scope

- What Service1 returns when Service2's catalog is empty: no computed value,
no default, and no error response is defined for this case in this version.
- Any alternative response shape, variant, or optional field on either
service's OpenAPI contract for an empty catalog — Service1's average
endpoint documents only the successful average, and Service2's catalog
endpoint documents only the catalog shape.
- Authentication or authorization for Service1 — access is open.
- Any web application or UI — both services are backend APIs only, with no
front end in this version.
- A human operator role for Service2's mode switch — it is an internal/test
hook, not a feature used by a named actor.

## Open Questions

None — the idea statement and interview answers settle every decision this
version needs.