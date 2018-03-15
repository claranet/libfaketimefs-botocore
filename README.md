# libfaketimefs-botocore

This patches [botocore](https://github.com/boto/botocore) to work while [libfaketime](https://github.com/wolfcw/libfaketime) and [libfaketimefs](https://github.com/claranet/libfaketimefs) are being used to modify the system time.

## Problem

The botocore package signs AWS requests using the current time. AWS uses this time stamp to protect against replay attacks and denies all requests that are not within 5 minutes of the real time. When libfaketime is configured to modify the time by more than 5 minutes, all requests made to AWS are denied and all AWS functionality is broken.

## Solution

This package monkey-patches botocore to use the real time provided by libfaketimefs, rather than using the fake time from libfaketime. It reads the `/realtime` file provided by libfaketimefs and uses that time when signing requests.

### botocore:

Here is what happens when botocore is used without libfaketime.

1. botocore asks for the current time
1. the system returns the real time
1. botocore signs the request with the real time
1. AWS accepts the request

### botocore + libfaketime:

Here is what happens when botocore is used while libfaketime is configured to modify the time by more than 5 minutes.

1. botocore asks for the current time
1. libfaketime returns the modified time
1. botocore signs the request with the modified time
1. AWS denies the request

### botocore + libfaketime + libfaketimefs-botocore:

Here is what happens when libfaketimefs-botocore is used to solve the problem.

1. botocore asks for the current time
1. libfaketimefs-botocore returns the time from `/realtime`
1. botocore signs the request with the real time
1. AWS accepts the request

## Usage

### Step 1:

Set the `FAKETIME_REALTIME_FILE` environment variable to the libfaketimefs `/realtime` path to enable libfaketimefs-botocore. Without this environment variable, the step 2 will have no effect.

```
export FAKETIME_REALTIME_FILE=/run/libfaketimefs/realtime
```

### Step 2a: Patch botocore using an import statement:

```python
import libfaketimefs_botocore.patch
```

### Step 2b: Patch botocore using a function call:

```python
import libfaketimefs_botocore

libfaketimefs_botocore.patch_botocore()
```
