#!/bin/bash
# Name :- EDMS_Monitoring
# Purpose :- Monitoring Daily Tasks
# Version :- I
# Created Date:- Tue Sep  5 03:10:08 PM IST 2023
# Modified Date:- 
# Author :- Rohit Radhakrishnan
#################### Start of the Script #################
---------------------------------------------------------
#!/bin/bash
echo " ################################### THIRUVANANTHAPURAM ######################################"
echo " *****************************************************************************" 
echo "          PING STATUS " 
echo " *****************************************************************************"
date
for ip in '10.66.114.4' '10.66.114.5' '10.66.114.6' '10.66.114.10' '10.66.114.11' '10.66.114.12' '10.66.114.20' '10.66.114.21' '10.66.114.22' '10.66.114.37' '10.66.114.38' '10.66.114.39' '10.31.6.51' '10.31.6.44' '10.240.26.71'

do
    ping  "$ip" -c1 > /dev/null
    if [ $? -eq 0 ]; then    #if exit status is true(0) means got successful execution
    echo "node $ip is up " 
    else
    echo  " DOWN !!! node $ip is DOWN !!! "
   
    fi 
done
echo "#############################################################################################################"

echo "______________________________________________________________________________________________________________"
echo  "## APPCluster ##"
export SSHPASS=Lic@doa078#
sshpass -e ssh -o UserKnownHostsFile=/dev/null  -o StrictHostKeyChecking=no   do_admin@10.66.114.10 /bin/bash<<EOT

echo " *****************************************************************************" 
echo "          SERVICE STATUS " 
echo " *****************************************************************************"
#sudo service --status-all
echo "
**AGENCYSYNCH Status**"
sudo service agencysynch status
echo "
**SYNCH Status**"
sudo service synch status
echo "
**DOCKETSERVICE Status**"
sudo service DocketService status
echo "
**JBOSS-EAP-RHEL Status**"
sudo service jboss-eap-rhel status 
echo "
**MI_ARCHIVALOFEDIFIBONDS Status**"
sudo service MI_ArchivalOfEdigiBonds status
echo "
**UPLOADARCHIVAL Status**"
sudo service uploadarchival status
echo "
**EPOLICYINSERT Status**"
sudo service epolicyinsert status
echo "
**IRDOCDOWNLOAD Status**"
sudo service irdocdownload status
echo "
**NEWGENLDAP Status**"
sudo systemctl status NewgenLdap
echo "
**Chronyd Status**"
sudo systemctl status chronyd | grep -i run
echo "
**NODE_EXPORTER Status**"
sudo systemctl status node_exporter | grep -i run
echo "
**DS_AGENT Status**"
sudo systemctl status ds_agent | grep -i run
echo "
**NEWGENWRAPPER Status**"
ps -ef | grep -i wrapper
echo "
**SMS Status**"
ps -ef | grep -i sms
echo "
**THUMBNAILSCHEDULE Status**"
ps -ef | grep -i thumbnailschedule
echo "
**SCHEDULER Status**"
ps -ef | grep -i scheduler
echo "
**NEWGENALARM Status**"
ps -ef | grep -i alarm
echo "
**NEWGENTHM Status**"
ps -ef | grep -i NewgenTHM

echo "########################################################################################################"
echo " *****************************************************************************" 
echo "          APP CLUSTER STATUS " 
echo " *****************************************************************************"
sudo pcs status

echo "########################################################################################################"
echo " *****************************************************************************" 
echo "         APP CLUSTER  MEMORY STATUS" 
echo " *****************************************************************************" 
free -h | grep -i mem 
free -h | grep -i mem | awk '{printf "Memory used percentage : %.2f%\n",(\$3/\$2*100)}'

echo "###########################################################################################################"
echo " *****************************************************************************" 
echo "         APP CLUSTER CPU UTILIZE DETAIL" 
echo " *****************************************************************************" 
top -b -n 1  | grep Cpu 
mpstat -u 2 5 | grep -i average | awk '{printf "CPU used percentage: %.2f%\n",(100-\$12)}'

echo "#######################################################################################################"
echo " *****************************************************************************" 
echo "         APP CLUSTER PARTITION STATUS " 
echo " *****************************************************************************" 
df -h

EOT

echo "____________________________________________________________________________________________________________"
echo  "## DBCluster ##"
export SSHPASS=Lic@doa078#
sshpass -e ssh -o UserKnownHostsFile=/dev/null  -o StrictHostKeyChecking=no   do_admin@10.66.114.20 /bin/bash<<EOT

echo " *****************************************************************************" 
echo "          SERVICE STATUS " 
echo " *****************************************************************************" 
systemctl status postgresql-10.service | grep Active
echo "
**Chronyd Status**"
sudo systemctl status chronyd | grep -i run
echo "
**NODE_EXPORTER Status**"
sudo systemctl status node_exporter | grep -i run
echo "
**DS_AGENT Status**"
sudo systemctl status ds_agent | grep -i run
echo "#############################################################################################################"
echo " *****************************************************************************" 
echo "          DB CLUSTER STATUS " 
echo " *****************************************************************************" 
sudo pcs status 

echo "############################################################################################################"
echo " *****************************************************************************" 
echo "          DB CLUSTER  MEMORY STATUS" 
echo " *****************************************************************************" 
free -h | grep -i mem 
free -h | grep -i mem | awk '{printf "Memory used percentage : %.2f%\n",(\$3/\$2*100)}'


echo "#############################################################################################################"
echo " *****************************************************************************" 
echo "          DB CLUSTER CPU UTILIZE DETAIL" 
echo " *****************************************************************************" 
top -b -n 1  | grep Cpu 
mpstat -u 2 5 | grep -i average | awk '{printf "CPU used percentage: %.2f%\n",(100-\$12)}'


echo "##############################################################################################################"
echo " *****************************************************************************" 
echo "          SYNCH STATUS " 
echo " *****************************************************************************" 
cd /home/do_admin
sh SynchCount.sh

echo "##############################################################################################################"
echo " *****************************************************************************" 
echo "          DB CLUSTER PARTITION STATUS " 
echo " *****************************************************************************" 
df -h

echo "
#10.66.114.20
base & pg_wal size"
sudo du -shc /dbdata1/data/base
sudo du -shc /dbdata1/data/pg_wal

EOT

echo " 
Backup Server"
export SSHPASS=Lic@doa078#
sshpass -e ssh -o UserKnownHostsFile=/dev/null  -o StrictHostKeyChecking=no   do_admin@10.66.114.6 /bin/bash<<EOT

echo " *****************************************************************************" 
echo "          SERVICE STATUS " 
echo " *****************************************************************************" 
echo "
**Chronyd Status**"
sudo systemctl status chronyd | grep -i run
echo "
**NODE_EXPORTER Status**"
sudo systemctl status node_exporter | grep -i run
echo "
**DS_AGENT Status**"
sudo systemctl status ds_agent | grep -i run
echo "###############################################################################################################"
echo " *****************************************************************************" 
echo "          BACKUP SERVER PARTITION STATUS " 
echo " *****************************************************************************" 
df -h

echo "###############################################################################################################"
echo " *****************************************************************************" 
echo "              DB DAILY BACKUP STATUS " 
echo " *****************************************************************************" 
sudo su - barman
barman show-backup bkp078 last

echo "################################################################################################################"
echo " *****************************************************************************" 
echo "              DB HDD BACKUP " 
echo " *****************************************************************************" 
barman list-backup bkp078
exit

echo "################################################################################################################"
echo " *****************************************************************************" 
echo "              DB_60DAYS BACKUP " 
echo " *****************************************************************************" 
ls -ltr /mnt/DB_60days/bkp078/base | tail -10
sudo du -sh /mnt/DB_60days/bkp078/base/* | tail -2

echo "################################################################################################################"
echo " *****************************************************************************" 
echo "              DB TDO BACKUP LOG " 
echo " *****************************************************************************" 
cd /var/log/rsync
cat barman_TDO_$(date +%F)* | tail -3

echo "#################################################################################################################"
echo " *****************************************************************************" 
echo "              DB_1YEAR BACKUP  " 
echo " *****************************************************************************" 
ls -ltr /mnt/DB_1yr/ | tail -3
sudo du -shc /mnt/DB_1yr/*

echo "#################################################################################################################"
echo " *****************************************************************************" 
echo "              DB TDO BACKUP " 
echo " *****************************************************************************" 
cd /var/log/rsync
cat barman_TDO_$(date +%F)* | tail -3

echo "#################################################################################################################"
echo " *****************************************************************************" 
echo "              LAST WALS ON TAPE " 
echo " *****************************************************************************" 
cd /mnt/DB_60days/bkp078/wals
ls -ltr | tail -10

echo "#################################################################################################################"
echo " *****************************************************************************" 
echo "              #Tape Image_noretention backup" 
echo " *****************************************************************************" 
cd /var/log/rsync/CP
echo "#/imagedata1"
cat APP_backup_imagedata1_bo_*$(date +%F)* | tail -4
echo "
#/imagedata2"
cat APP_backup_imagedata2_bo_*$(date +%F)* | tail -4
echo "
#/imagedata3"
cat APP_backup_imagedata3_bo_*$(date +%F)* | tail -4
echo "
#/imagedata4"
cat APP_backup_imagedata4_bo_*$(date +%F)* | tail -4
echo "
#/imagedata5"
cat APP_backup_imagedata5_bo_*$(date +%F)* | tail -4
echo "
#/imagedata6"
cat APP_backup_imagedata6_bo_*$(date +%F)* | tail -4
echo "
#/imagedata7"
cat APP_backup_imagedata7_bo_*$(date +%F)* | tail -4
echo "
#/imagedata8"
cat APP_backup_imagedata8_bo_*$(date +%F)* | tail -4
echo "
#/imagedata9"
cat APP_backup_imagedata9_bo_*$(date +%F)* | tail -4
echo "
#/imagedata10"
cat APP_backup_imagedata10_bo_*$(date +%F)* | tail -4
echo "
#/imagedata11"
cat APP_backup_imagedata11_bo_*$(date +%F)* | tail -4
echo "
#/imagedata12"
cat APP_backup_imagedata12_bo_*$(date +%F)* | tail -4
echo "
#/imagedata13"
cat APP_backup_imagedata13_bo_*$(date +%F)* | tail -4



echo " *****************************************************************************" 
 
echo "              LAG SIZE " 
echo " *****************************************************************************"
sudo su - barman
barman replication-status bkp078
exit

EOT

echo "################################### THIRUVANANTHAPURAM ######################################"

---------------------------------------------------------
#################### THE END ############################
