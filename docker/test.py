import boto3
import datetime
import libfaketimefs_botocore.patch


fake_date = datetime.date.today()

with open('/etc/realtime') as open_file:
    real_date = datetime.datetime.fromtimestamp(int(open_file.read())).date()

print 'real date: {}'.format(real_date)
print 'fake date: {}'.format(fake_date)

assert fake_date != real_date

kms = boto3.client('kms')
s3 = boto3.client('s3')

for key in kms.list_keys()['Keys'][:3]:
    print key['KeyArn']

for bucket in s3.list_buckets()['Buckets'][:3]:
    print 's3://' + bucket['Name']
