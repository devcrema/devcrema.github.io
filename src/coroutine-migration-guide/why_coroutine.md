# why coroutine?

## 성능
- 쓰레드 하나를 여러 작업으로 concurrently하게 나누어서 사용할 수 있음
- 하나의 코루틴이라는 개념은 하나의 쓰레드보다 작은 개념이기 때문에 메모리 사용량을 더 줄일 수 있음

## 가독성
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
## 편의성
- reactor에서 zip하는 순간 tuple로 묶이기 때문에 가독성을 저하시키고 사용을 불편하게 만들지만
- coroutine에서는 async await로 가독성을 유지한채로 async하게 동작시킬 수 있음
- Mono에서는 null을 사용할 수 없어 empty로 처리해야하지만 suspend fun은 nullable이나 null을 반환할 수 있다.

### reactor concurrency
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
### coroutine concurrency
```kotlin
val cat = CoroutineScope(Dispatchers.IO).async { "cat" }
val dog = CoroutineScope(Dispatchers.IO).async { "dog" }
val hamster = CoroutineScope(Dispatchers.IO).async { "hamster" }

println(cat.await())
println(dog.await())
println(hamster.await())
```
