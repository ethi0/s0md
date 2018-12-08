echo "[gates]" > hosts
echo --- > domains.yml
echo domains: >> domains.yml
echo > $(dirname $0)/d.list

ls $(dirname $0) | egrep -v '(ssl_check.sh|backup|backup.sh|spcomparator.sh|spbd.sh|spbd|randomlist|ipset_new.yml|xargservch.sh|xargavailch.sh|rootnscheck.sh|backup|errors|iptables.sh|passgen.sh|checkdel.sh|tmp|whoismask.sh|addkey.sh|portcheck.sh|voip2.sh|voip.sh|anotef|syncssl.sh|nx_norm.sh|verlog|ipset.yml|enc.sh|dec.sh|salt|man.sh|rules|announcer.sh|menudns.sh|menuwdns.sh|scenaries|domfinalizer.sh|domainsyncch.sh|additionalscan.sh|datacollector.sh|availabilitych.sh|ticket.sh|anote.sh|ssv.sh|scl.sh|report.log|way.log|d.list|acme.sh|addom.sh|autobuy.sh|autoswitcher.sh|backup_ansible.sh|backup_server.sh|backup.sh|checkdomain_cls.sh|checkdomain.csv|checkdomain.sh|cleaner.sh|client|comparator.sh|cont_check.sh|del_dom.sh|detector.sh|digger.sh|domanalizer.sh|domfill.sh|enhostdom|enhosts_new_gate.sh|enhosts.sh|ex.sh|fgroup.list|fgroup.list2|gate_elim.sh|inspector.sh|ipsetcheck.sh|ipsetkiller.sh|ipset.sh|mail_composer.sh|monitor.sh|monitor_sv.sh|new_gate.sh|prexecutor_server.sh|prexecutor.sh|server|servicech.sh|somd_cl.sh|somd.sh|somd_sv.sh|spider.sh|switcher_server.sh|switcher.sh|wdnsex.sh|sp_ex.sh|sp_exip.sh|sp_wex.sh|sp_pr.sh|sp_in.sh)' > list
for i in `cat list`; do
  r="$(dirname $0)/$i"
  rm $r > /dev/null 2>&1; 
  done

if [ -z "`ls $(dirname $0)/domains`" ]
  then
  echo Empty > /dev/null 2>&1
  else
rm -r $(dirname $0)/domains/*
fi

if [ -z "`ls $(dirname $0)/registrar`" ]
  then
  echo Empty > /dev/null 2>&1
  else
rm -r $(dirname $0)/registrar/*
fi

chmod -R 777 $(dirname $0)/anotef/ > /dev/null 2>&1
rm -r $(dirname $0)/anotef/* > /dev/null 2>&1
rm -r $(dirname $0)/anotef/.acme.sh/ > /dev/null 2>&1
