import os
from pathlib import Path
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
labels = ['imei', 'IMSI', 'ICCID', 'equipment id', 'equipment identifier',
          'sim identifier', 'modem.generic.equipment-identifier',
          'sim.properties.imsi', 'sim.properties.iccid', 'sim.properties.identifier']
for label in labels:
    for value in ['123456789012345', "'123456789012345'", '"123456789012345"']:
        sample = f'{label} : {value}\n'
        result = subprocess.run(['bash', '-c', 'source "$1"; redact_stream', '_',
                                 str(root/'lib/common.sh')], input=sample,
                                text=True, capture_output=True, check=True)
        assert result.stdout == f'{label} : <redacted>\n', result.stdout
sample = 'model: L850-GL\nsignal quality: 75\n'
r = subprocess.run(['bash','-c','source "$1"; redact_stream','_',str(root/'lib/common.sh')],
                   input=sample,text=True,capture_output=True,check=True)
assert r.stdout == sample
with tempfile.TemporaryDirectory() as tmp:
    prefix = Path(tmp)/'prefix with spaces'
    subprocess.run(['bash',str(root/'install.sh')],env={**os.environ,'PREFIX':str(prefix)},check=True)
    for cmd in ['help','version']:
        r=subprocess.run([str(prefix/'bin/wwanctl'),cmd],text=True,capture_output=True,check=True,cwd='/')
        assert not r.stderr, r.stderr
        assert 'wwan' in r.stdout
for p in list((root/'lib').glob('*.sh'))+[root/'install.sh',root/'bin/wwanctl']:
    subprocess.run(['bash','-n',str(p)],check=True)
print('Passed: identifier formats, unrelated text, installed launcher and shell syntax.')

# Bundle creation must not reuse/delete an existing timestamp directory.
with tempfile.TemporaryDirectory() as tmp:
    previous=Path(tmp)/'wwan-diag-bundle-fixture-fixed'
    previous.mkdir(); (previous/'keep').write_text('untouched')
    script = r'''source "$1/lib/common.sh"
source "$1/lib/bundle.sh"
WWAN_DIAG_VERSION=test
hostname() { echo fixture; }
date() { echo fixed; }
have() { return 1; }
print_system() { :; }; print_services() { :; }; print_rfkill() { :; }
print_networkmanager() { :; }; print_modemmanager() { :; }
print_hardware() { :; }; print_final_summary() { :; }
create_bundle
create_bundle
'''
    subprocess.run(['bash','-c',script,'_',str(root)],cwd=tmp,check=True,capture_output=True)
    assert (previous/'keep').read_text()=='untouched'
    archives=list(Path(tmp).glob('*.tar.gz'))
    assert len(archives)==2
    assert all(p.stat().st_mode & 0o777 == 0o600 for p in archives)
print('Passed: unique bundle directories and private archive permissions.')
