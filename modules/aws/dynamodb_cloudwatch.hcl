ingester aws_dynamodb_table_operation_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "dynamodb"
    name = "$input{TableName}"
  }

  data_for_graph_node {
    type = "dynamodb_operation"
    name = "$input{Operation}"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "system_errors" {
    unit = "count"

    source cloudwatch "system_errors" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "SystemErrors"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }

  gauge "returned_items" {
    unit = "count"

    source cloudwatch "returned_items" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ReturnedItemCount"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }

  gauge "throttled" {
    unit = "count"

    source cloudwatch "latency_update" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ThrottledRequests"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }

  gauge "latency" {
    unit = "ms"

    source cloudwatch "latency" {
      query {
        aggregator  = "Average"
        namespace   = "AWS/DynamoDB"
        metric_name = "SuccessfulRequestLatency"

        dimensions = {
          "TableName" = "$input{TableName}"
          "Operation" = "$input{Operation}"
        }
      }
    }
  }
}

ingester aws_dynamodb_table_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "dynamodb"
    name = "$input{TableName}"
  }

  data_for_graph_node {
    type = "dynamodb"
    name = "$input{TableName}"
  }

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  gauge "rcu" {
    unit = "count"

    source cloudwatch "rcu" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ConsumedReadCapacityUnits"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }

  gauge "wcu" {
    unit = "count"

    source cloudwatch "wcu" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ConsumedWriteCapacityUnits"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }

  gauge "read_throttled" {
    unit = "count"

    source cloudwatch "read_throttled" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "ReadThrottledEvents"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }

  gauge "write_throttled" {
    unit = "count"

    source cloudwatch "write_throttled" {
      query {
        aggregator  = "Maximum"
        namespace   = "AWS/DynamoDB"
        metric_name = "WriteThrottledEvents"

        dimensions = {
          "TableName" = "$input{TableName}"
        }
      }
    }
  }
}