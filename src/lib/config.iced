
exports.config =
  derive:
    initial_delay : 500
    internal_delay : 1
    iters_per_slot : 10
  pw :
    min_size : 8
    max_size : 16
  timeouts :
    cache : 5*60
    document : 2*60
    input : 5*60
  
    
