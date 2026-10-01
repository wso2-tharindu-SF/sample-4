import ballerina/os;

// The address service2 is reachable at, injected by the platform for the
// `component`-kind dependency wired in workload.yaml. May end in `/` — never
// string-concatenate a path onto it, join it instead (see service2_client.bal).
configurable string service2Url = os:getEnv("SERVICE2_URL");
