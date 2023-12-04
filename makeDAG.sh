
#path to makeDAG, dont change this
makeDAG=/mnt/bigdata/linuxhome/jwolters/pipelines/hybpiper/v1/makeDAG.py

#fix your pythonpath to include pydagman, generally this won't need to changed
export PYTHONPATH=$PYTHONPATH:/mnt/bigdata/linuxhome/jwolters/packages

/opt/bifxapps/python/bin/python2.7 $makeDAG
