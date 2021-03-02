# Overview

## coroutine이란?
- co-routine, 협력하는 루틴이라는 뜻
- 코루틴은 쉽게 말해 하나의 비동기로 실행할 수 있는 함수라고 이해할 수 있음
- 코루틴은 경량화된 쓰레드를 지원하는 패러다임으로 볼 수 있음
- 경량화된 쓰레드라는 뜻은 하나의 쓰레드를 루틴마다 일시정지하며 비동기적으로 활용할 수 있기 때문임
- kotlin 뿐만 아니라 go, python 등 다양한 언어에서 지원하고 있음

## JAVA와의 관계
- 현재 coroutine은 자바 코드를 호출할 수는 있지만 자바에서 kotlin coroutine을 호출하면 제대로 동작을 보장하지 않음
- 대부분의 major한 프레임워크에서 지원하지만 일부 미지원하는 부분이 존재하고 있음

## Reactive Stream Library 와의 관계
- RxJava, Reactor와 같은 Reactive stream 라이브러리들과는 반대되는 관계가 아님
- 아직 수많은 프레임워크와 라이브러리들이 위 두개의 reactive 라이브러리들을 사용하기 있기 때문에 coroutine에서는 연동을 위한 모듈을 지원하고 있음

