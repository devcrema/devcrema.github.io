# example
[Github Link](https://github.com/devcrema/spring-webflux-grpc-coroutine-example)

### SchedulerAndDispatcher
```kotlin
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.reactor.asCoroutineDispatcher
import reactor.core.scheduler.Scheduler
import reactor.core.scheduler.Schedulers

object SchedulerAndDispatcher {
    val IO_SCHEDULER : Scheduler = Schedulers.newBoundedElastic(10, Int.MAX_VALUE, "reactor-io")
    val IO_DISPATCHER: CoroutineDispatcher = IO_SCHEDULER.asCoroutineDispatcher()
}
```
### TestRepository
```kotlin
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.reactive.asFlow
import kotlinx.coroutines.reactive.awaitFirstOrNull
import org.springframework.stereotype.Repository
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono

@Repository
class TestRepository(
        private val testReactiveRepository: TestReactiveRepository,
        private val testJpaRepository: TestJpaRepository
){

    suspend fun findById(): String? = testReactiveRepository.findById().awaitFirstOrNull()
    suspend fun findAll(): Flow<String> = testReactiveRepository.findAll().asFlow()

    // unlike Mono, you can just call it with null
    suspend fun findByIdWithJpa(): String? = testJpaRepository.findByIdOrNull()
    suspend fun findAllWithJpa(): List<String> = testJpaRepository.findAll()
}

@Repository
class TestReactiveRepository{
    fun findAll(): Flux<String> = Flux.just("this ", " is ", " coroutine", " flow")
    fun findById(): Mono<String> = Mono.just("hello world!!!")
}

@Repository
class TestJpaRepository {
    fun findAll(): List<String> = listOf("this ", " is ", " coroutine ", " flow ")
    fun findByIdOrNull(): String? = "hell world!!!"
}
```
### grpc service
```kotlin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.async
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactor.mono
import org.lognet.springboot.grpc.GRpcService
import reactor.core.publisher.Mono

@GRpcService
class HelloGrpcService(private val testRepository: TestRepository)
    : ReactorHelloServiceGrpc.HelloServiceImplBase() {

    override fun getHello(request: Mono<Hello.Name>): Mono<Hello.Response> = request
            .flatMap { requestName ->
                mono(SchedulerAndDispatcher.IO_DISPATCHER) {
                    val getSuspend = CoroutineScope(SchedulerAndDispatcher.IO_DISPATCHER).async {
                        testRepository.findById()
                    }
                    val getFlowAsList = CoroutineScope(SchedulerAndDispatcher.IO_DISPATCHER).async {
                        testRepository.findAll().toList()
                    }
                    "hello ${requestName.value}\n${getFlowAsList.await()}\n${getSuspend.await()}"
                }
            }
            .map { result ->
                Hello.Response.newBuilder()
                        .setMessage(result)
                        .build()
            }

}
```