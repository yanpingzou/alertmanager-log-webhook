#!/bin/bash

alerts1='{
    "alerts": [
        {
            "annotations": {
                "description": "CPU usage above 90% more than 5 minutes (current: 90.6%)",
                "summary": "Instance CPU usgae high"
            },
            "endsAt": "2019-08-03T18:03:36.755145064+08:00",
            "generatorURL": "http://d98c1e130bb2:9090/graph?g0.expr=round%28100+%2A+sum+by%28instance%2C+env%29+%28avg+without%28cpu%29+%28irate%28node_cpu_seconds_total%7Bmode%21%3D%22idle%22%7D%5B5m%5D%29%29%29%2C+0.1%29+%3E+90u0026g0.tab=1",
            "labels": {
                "alertname": "CpuUsageHigh",
                "env": "dev",
                "instance": "172.16.20.122:9100",
                "severity": "Warning"
            },
            "startsAt": "2019-08-03T18:02:21.755145064+08:00",
            "status": "resolved"
        }
    ],
    "commonAnnotations": {
        "description": "CPU usage above 90% more than 5 minutes (current: 90.6%)",
        "summary": "Instance CPU usgae high"
    },
    "commonLabels": {
        "alertname": "CpuUsageHigh",
        "env": "dev",
        "instance": "172.16.20.122:9100",
        "severity": "Warning"
    },
    "externalURL": "http://b76201acf8a2:9093",
    "groupKey": "{}/{}:{alertname=\"CpuUsageHigh\", env=\"dev\", severity=\"Warning\"}",
    "groupLabels": {
        "alertname": "CpuUsageHigh",
        "env": "dev",
        "severity": "Warning"
    },
    "receiver": "web.alertmanager_log_webhook",
    "status": "resolved",
    "version": "4"
}'

curl -XPOST -d"$alerts1" http://localhost:8061/webhook
