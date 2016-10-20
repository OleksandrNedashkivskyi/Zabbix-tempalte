## Installation instruction

1. Copy iostat-collect.sh, iostat-descovery.sh, iostat-parse.sh to some directory, for example /tmp/iostat
2. Change path for the variable **SOURCE_DATA** in files iostat-collect.sh and iostat-parse.sh.It is responsible where iostat.out (statistic file) will be saved.
3. Change path in iostat-params.conf to path from 1 point. Copy 3 lines into zabbix-agentd.conf and restart Zabbix Agent
4. Import iostat-template.xml into Zabbix