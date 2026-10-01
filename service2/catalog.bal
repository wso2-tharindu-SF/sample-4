import ballerina/log;

// The catalog's current serving mode. Starts in full mode per the contract.
type CatalogMode "full"|"empty";

// Fixed, verbatim seed data for full mode (sum of scores = 357).
final Record[] fullCatalogRecords = [
    {id: 1, name: "Alpha", score: 40},
    {id: 2, name: "Bravo", score: 35},
    {id: 3, name: "Charlie", score: 30},
    {id: 4, name: "Delta", score: 45},
    {id: 5, name: "Echo", score: 25},
    {id: 6, name: "Foxtrot", score: 50},
    {id: 7, name: "Golf", score: 20},
    {id: 8, name: "Hotel", score: 38},
    {id: 9, name: "India", score: 33},
    {id: 10, name: "Juliett", score: 41}
];

// In-memory singleton state — no persistence dependency is declared for this component.
CatalogMode currentMode = "full";

// Builds the catalog for whichever mode is currently active, logging the record count handled.
function currentCatalog() returns Catalog {
    Record[] records = currentMode == "full" ? fullCatalogRecords : [];
    log:printInfo("catalog request handled", mode = currentMode, recordCount = records.length());
    return {mode: currentMode, records: records.clone()};
}

// Validates and applies a requested mode change. An unrecognized mode is rejected with
// a 400 and the structured Error schema — never accepted as a new mode.
function applyModeChange(string requestedMode) returns Catalog|ErrorBadRequest {
    if requestedMode != "full" && requestedMode != "empty" {
        Error errorBody = {
            code: 400,
            message: "Invalid mode",
            description: string `Unrecognized mode '${requestedMode}'; expected 'full' or 'empty'`
        };
        return <ErrorBadRequest>{body: errorBody};
    }
    currentMode = <CatalogMode>requestedMode;
    return currentCatalog();
}
