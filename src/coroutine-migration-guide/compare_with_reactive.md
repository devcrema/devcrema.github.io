# Compare with Reactive

## compare with other reactive stream library

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
