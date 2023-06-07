{
  FunctionName: 'sfn-dist-k6',
  Handler: 'function.handler',
  MemorySize: 128,
  Role: 'arn:aws:iam::{{ must_env `AWS_ACCOUNT_ID` }}:role/AWSLambdaBasicExecutionRole',
  Runtime: 'provided.al2',
  Timeout: 900,
}
