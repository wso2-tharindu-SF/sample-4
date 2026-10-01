import service1.service2client;

// A trailing slash on the injected address is normalized here, once, rather
// than string-concatenating a path onto it at every call site.
function normalizeBaseUrl(string baseUrl) returns string {
    if baseUrl.endsWith("/") {
        return baseUrl.substring(0, baseUrl.length() - 1);
    }
    return baseUrl;
}

final service2client:Client service2Client = check new (normalizeBaseUrl(service2Url));

// Fetches whatever catalog service2 currently serves. Never calls
// `/operations/mode` — service1 only reads the catalog.
function fetchCatalog() returns service2client:Catalog|error {
    return service2Client->/catalog.get();
}
