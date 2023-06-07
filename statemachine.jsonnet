local env = import 'env.json';
{
  Comment: 'A description of my state machine',
  StartAt: 'Map',
  States: {
    Map: {
      Type: 'Map',
      ItemProcessor: {
        ProcessorConfig: {
          Mode: 'DISTRIBUTED',
          ExecutionType: 'STANDARD',
        },
        StartAt: 'Lambda Invoke',
        States: {
          'Lambda Invoke': {
            Type: 'Task',
            Resource: 'arn:aws:states:::lambda:invoke',
            OutputPath: '$.Payload',
            Parameters: {
              'Payload.$': '$',
              FunctionName: 'arn:aws:lambda:ap-northeast-1:%s:function:sfn-dist-k6:current' % env.AWS_ACCOUNT_ID,
            },
            Retry: [
              {
                ErrorEquals: [
                  'Lambda.ServiceException',
                  'Lambda.AWSLambdaException',
                  'Lambda.SdkClientException',
                  'Lambda.TooManyRequestsException',
                ],
                IntervalSeconds: 2,
                MaxAttempts: 6,
                BackoffRate: 2,
              },
            ],
            End: true,
          },
        },
      },
      End: true,
      Label: 'Map',
      MaxConcurrency: 1000,
      ResultWriter: {
        Resource: 'arn:aws:states:::s3:putObject',
        Parameters: {
          Bucket: 'sfn-dist-k6-results',
          Prefix: 'summaries/',
        },
      },
    },
  },
}
