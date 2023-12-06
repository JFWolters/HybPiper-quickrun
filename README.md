# HybPiper-quickrun
Run HybPiper parallelized on scarcity
An alternate single run option is also provided.

## Single run
Copy run_hybpiper.sh into the desired run folder, modify the input and targets file paths, and run with bash.
Only recommended for small numbers of read sets, for large datasets use the pipeline version below.

##DAG Pipeline
Copy vars.config and makeDAG.sh into run folder. Modify vars.config as needed, "[]" around variables needing adjustment.
Run "bash makeDAG.sh".
Run "condor_submit_dag hybpiper.dag".
