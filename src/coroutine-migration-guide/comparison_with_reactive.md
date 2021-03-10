# Comparison with Reactive

## comparison with reactive libraries

| Feature | RxJava | Reactor | Coroutine |
| ----- | ----------- | ----------- | ------- |
| 여러번 발행 가능한 스트림 | Flowable<T> | Flux<T> | Flow<T> |
| 한번만 발행 가능한 단일 value 스트림 | Maybe<T> | Mono<T> | suspend fun |
| 시작 스케줄러 지정 | .subscribeOn(Scheduler) | .subscribeOn(Scheduler) | CoroutineScope(Dispatcher) |
| 중간 스케줄러 지정 | .observeOn(Scheduler) | .publishOn(Scheduler) | Flow: flowOn(Dispatcher) </br> suspend fun: CoroutineScope(Dispatcher)
| block | .blockingGet() | .block() | runBlocking { /* coroutine codes */ } |
| 변환 | .map {} | .map {} | Flow: .map {} </br> suspend fun: just using imperative codes |
| 필터 | .filter {} | .filter {} | Flow : .filter {} </br> suspend fun: just using imperative codes |
| List로 변환 | Flowable.toList() | Flux.collectList() | Flow.toList() |

## reactor flatMap vs coroutine suspend
### Mono
```kotlin
Mono.just(1000)
    .subscribeOn(Schedulers.boundedElastic())
    .flatMap { money -> monoBuy(money) }
    .flatMap { result -> monoRefund(result) }
    .subscribe({
        log.info("success $it")
    }, {
        log.info("failed $it")
    })
```
### suspend
```kotlin
val money = 1000
try {
    val receipt = suspendBuy(money)
    val result = suspendRefund(receipt)
    log.info("success $result")
} catch (e: Exception) {
    log.info("failed $e")
}
```
## reactor subscribeOn vs coroutine withContext
### reactor subscribeOn
```kotlin
Mono.fromCallable { "inside reactor scheduler" }
    .subscribeOn(Schedulers.boundedElastic())
```
### coroutine withContext
```kotlin
withContext(Dispatchers.IO) {
    "inside coroutine dispatcher"
}
```
## reactor subscribe vs coroutine launch
### reactor subscribe
```kotlin
Mono.fromCallable { "inside mono" }
    .subscribe { message -> log.info("$message") }
```
### coroutine launch
```kotlin
CoroutineScope(Dispatchers.IO).launch {
    log.info("inside coroutine")
}
```

## reactor zip vs coroutine async
### reactor zip
```kotlin
val cat = Mono.just("cat")
        .subscribeOn(Schedulers.parallel())

val dog = Mono.just("dog")
        .subscribeOn(Schedulers.parallel())

val hamster = Mono.just("hamster")
        .subscribeOn(Schedulers.parallel())
val result = Mono.zip(job1, job2, job3).block()

println(result.t1)
println(result.t2)
println(result.t3)
```
### coroutine async
```kotlin
val cat = CoroutineScope(Dispatchers.IO).async { "cat" }
val dog = CoroutineScope(Dispatchers.IO).async { "dog" }
val hamster = CoroutineScope(Dispatchers.IO).async { "hamster" }

println(cat.await())
println(dog.await())
println(hamster.await())
```

## reactor parallel flux vs coroutine parallel flow
### reactor parallel flux
```kotlin
Flux.range(1,10)
    .parallel(10)
    .runOn(Schedulers.newParallel("parallel", 10))
    .map { num ->
        sleep(1000)
        "$num received"
    }.subscribe { log.info("$it") }
```
### coroutine parallel flow
```kotlin

val dispatcher = Executors.newFixedThreadPool(10).asCoroutineDispatcher()
CoroutineScope(dispatcher).launch {
    (1..10).asFlow()
        .map { num ->
            this.async {
                sleep(1000)
                "$num received"
            }
        }
        .buffer(10)
        .map { deferred -> deferred.await() }
        .collect {
            log.info("$it")
        }
}
```

## handling error
### reactor
```kotlin
fun `reactor error handling test`() {
    Mono.just("").map {
        throw IllegalStateException("reactor mono error!!")
    }.map {
        "unreached"
    }.onErrorResume {
        Mono.just("$it")
    }.block().also { println("result: $it") }
}
```
### coroutine
```kotlin
fun `coroutine error handling test`() {
    val result = runBlocking {
        try {
            throwError()
        } catch (e: Exception) {
            "error $e"
        }
    }
    println("result :$result")
}

private suspend fun throwError() {
    delay(10)
    throw IllegalStateException()
}
```
