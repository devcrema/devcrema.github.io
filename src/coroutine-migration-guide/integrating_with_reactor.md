# integrating with reactor
- reactor와 RxJava 모두 reactive-stream interface를 지원하기 때문에 아래 모듈로 사용 가능함
- ex: Flux, Mono, Flowable 들은 모두 reactive-stream  org.reactivestreams.Publisher의 구현체임 

## dependency
해당 의존성만 추가해도 org.jetbrains.kotlinx:kotlinx-coroutines-reactive 를 사용할 수 있음
```kotlin
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-reactor")
```

## kotlinx-coroutines-reactive

### Reactive to Coroutine
- Publisher.asFlow `Flux.just("").asFlow()`
- Publisher.awaitFirst `Mono.awaitFirst()`
- Publisher.awaitFirstOrDefault `Mono.awaitFirstOrDefault()`
- Publisher.awaitFirstOrElse `Mono.awaitFirstOrElse()`
- Publisher.awaitFirstOrNull `Mono.awaitFirstOrNull()`
- Publisher.awaitLast `Mono.awaitLast(), Flux.awaitLast()`
- Publisher.awaitSingle `Mono.awaitSingle()`

### Coroutine to Reactive
- `Flow.asPublisher()`
- `publish(coroutineScope) { ... }`

## kotlinx-coroutines-reactor
### Reactor to Coroutine
- Scheduler.asCoroutineDispatcher
  - `val dispatcher = Schedulers.single().asCoroutineDispatcher()`
  - `withContext(dispatcher) { ... }`
  - 이렇게 스케줄러를 디스패처로 변환하더라도, 하나의 단일 스케줄러를 공유하여 사용함. 

### Coroutine to Reactor
- `mono(coroutineScope){ ... }`
- `flux(coroutineScope){ ... }`
- `Flow.asFlux`
- `Job.asMono`
- `Deferred.asMono`
- `ReceiveChannel.asFlux`
