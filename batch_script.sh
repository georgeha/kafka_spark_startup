#!/bin/bash

module load jdk64/1.8.0

SCHEDULER=`hostname`
hostnodes=`scontrol show hostnames $SLURM_NODELIST`
echo $hostnodes

#SETUP SPARK
cd /home/03662/tg829618/experiments-sbatch/spark-2.2.0-bin-hadoop2.7/conf
echo 'spark.master spark://'$SCHEDULER':7077' > spark-defaults.conf
echo 'export JAVA_HOME=/usr/java/jdk1.8.0_92' > spark-env.sh
echo 'export PYSPARK_PATH=/home/03662/tg829618/anaconda2/bin/python' >> spark-env.sh
echo 'export SPARK_MASTER_HOST='$SCHEDULER >> spark-env.sh
echo 'Spark Submit endpoint: ' $SCHEDULER:7077


#SETUP Kafka and start Zookeeper

cd /home/03662/tg829618/experiments-sbatch/
echo 'starting Zookeeper..'
cd /home/03662/tg829618/experiments-sbatch/kafka_2.11-0.8.2.1 		
./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
echo 'zk is running'
echo 'zookeeper.connect:' $SCHEDULER:2181

#Start kafka brokers
brokers_no=1
cd /home/03662/tg829618/experiments-sbatch/
python start_brokers.py $brokers_no 
