ingester aws_eks_containerinsights_service_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{K8sNamespace}"
  }

  physical_component {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "k8s_service"
    name = "$input{K8sService}"
  }

  gauge "running_pods" {
    unit = "count"
    aggregator = "SUM"

    source cloudwatch "service_number_of_running_pods" {
      query {
        aggregator  = "Sum"
        namespace   = "ContainerInsights"
        metric_name = "service_number_of_running_pods"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "Service"     = "$input{K8sService}"
        }
      }
    }
  }
}

ingester aws_eks_containerinsights_pod_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  label {
    type = "namespace"
    name = "$input{K8sNamespace}"
  }

  physical_component {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  physical_address {
    type = "k8s_pod"
    name = "$input{PodName}"
  }

  data_for_graph_node {
    type = "k8s_pod"
    name = "$input{PodName}"
  }

  gauge "cpu" {
    unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "pod_cpu_utilization" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_cpu_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }


  gauge "memory" {
    unit = "percent"
    aggregator  = "AVG"

    source cloudwatch "pod_memory_utilization" {
      query {
        aggregator  = "Average"
        namespace   = "ContainerInsights"
        metric_name = "pod_memory_utilization"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }

  gauge "restarts" {
    unit = "count"
    aggregator = "SUM"
    source cloudwatch "pod_number_of_container_restarts" {
      query {
        aggregator  = "Sum"
        namespace   = "ContainerInsights"
        metric_name = "pod_number_of_container_restarts"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
          "Namespace"   = "$input{K8sNamespace}"
          "PodName"     = "$input{PodName}"
        }
      }
    }
  }
}

ingester aws_eks_containerinsights_cluster_cloudwatch module {
  frequency  = 60
  lookback   = 600
  timeout    = 30
  resolution = 60
  lag        = 60

  using = {
    default = "$input{using}"
  }

  inputs = "$input{inputs}"

  label {
    type = "service"
    name = "$input{service}"
  }

  physical_component {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  data_for_graph_node {
    type = "k8s_cluster"
    name = "$input{ClusterName}"
  }

  gauge "total_nodes" {
    unit = "count"
    aggregator  = "MAX"

    source cloudwatch "cluster_node_count" {
      query {
        aggregator  = "Maximum"
        namespace   = "ContainerInsights"
        metric_name = "cluster_node_count"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }

  gauge "failed_nodes" {
    unit = "count"
    aggregator  = "MIN"
    source cloudwatch "cluster_failed_node_count" {
      query {
        aggregator  = "Minimum"
        namespace   = "ContainerInsights"
        metric_name = "cluster_failed_node_count"
        dimensions = {
          "ClusterName" = "$input{ClusterName}"
        }
      }
    }
  }
}
