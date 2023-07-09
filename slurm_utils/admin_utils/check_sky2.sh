#!/bin/bash
# Must run `sudo cp ~/.dot-files/slurm_utils/admin_utils/check_sky2.sh /etc/cron.hourly/check_sky2 && sudo chmod +x /etc/cron.hourly/check_sky2`
/srv/flash1/aszot3/miniconda3/bin/python /srv/flash1/aszot3/.dot-files/slurm_utils/admin_utils/usage_reporting.py --settings-name /coc/testnvme/aszot3/.cvmlp_info.yaml --test --override-channel skynet-monitoring
/srv/flash1/aszot3/miniconda3/bin/python /srv/flash1/aszot3/.dot-files/slurm_utils/admin_utils/kill_bad_jobs.py
/srv/flash1/aszot3/miniconda3/bin/python /srv/flash1/aszot3/.dot-files/slurm_utils/admin_utils/node_health_check.py
/srv/flash1/aszot3/miniconda3/bin/python /srv/flash1/aszot3/.dot-files/slurm_utils/admin_utils/usage_reporting.py --settings-name /coc/testnvme/aszot3/.cvmlp_info.yaml
/srv/flash1/aszot3/miniconda3/bin/python /srv/flash1/aszot3/.dot-files/slurm_utils/admin_utils/usage_reporting.py --settings-name /coc/testnvme/aszot3/.ripl_info.yaml

