
permissionset 60100 "VRM Admin"
{
    Assignable = true;
    Caption = 'VeriMatch Administrator';

    Permissions =
        tabledata "VRM Reconciliation Project" = RIMD,
        tabledata "VRM Import Buffer" = RIMD,
        tabledata "VRM Field Map" = RIMD,
        tabledata "VRM Match Candidate" = RIMD,

        table "VRM Reconciliation Project" = X,
        table "VRM Import Buffer" = X,
        table "VRM Field Map" = X,
        table "VRM Match Candidate" = X,

        codeunit "VRM Algorithm Lib" = X,
        codeunit "VRM Processor" = X,

        page "VRM Project List" = X,
        page "VRM Project Card" = X,
        page "VRM Field Mapping Subform" = X,
        page "VRM Match Worksheet" = X,

        page "VRM Project API" = X,
        page "VRM Buffer API" = X,
        page "VRM Candidate API" = X,
        page "VRM Mapping API" = X;

}