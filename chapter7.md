사전 정의 된 전역 변수 및 함수



계약이 EVM에서 실행되면, 글로벌 개체의 작은 집합에 액세스 할 수 있다. 여기에는 block, msg 및 tx 객체가 포함된다. 또한 솔리디티는 사전 정의 된 기능으로 다수의 EVM opcode를 제공한다. 이 장에서는 솔리디티의 스마트 계약 내에서 액세스 할 수있는 변수와 함수를 살펴 본다.

트랜잭션/메시지 콜 컨텍스트

msg 객체는 이 계약 실행을 시작한 거래 호출(EOA 발신) 또는 메시지 호출(계약 발신)이다. 여기에는 많은 유용한 속성이 포함되어 있다.

msg.sender

우리는 이미 이 것을 사용했다. 발신자는 이 계약 호출을 시작한 주소를 나타내며, 반드시 거래를 보낸 EOA는 아니다. 만약 EOA 거래가 계약을 직접 호출했다면, 이것은 거래에 서명한 주소이지만, 그렇지 않으면 계약 주소가 될 것이다.

msg.value

이 호출과 함께 전송된 이더의 값(wei).

msg.gas

이 실행 환경의 가스 공급에 남은 가스의 양이다. 이것은 솔리디티 v0.4.21에서 사용되지 않고 gasleft 함수로 대체되었습니다.

msg.data

이 호출의 데이터 페이로드가 우리 계약에 들어온다.

msg.sig

함수 선택기인 데이터 페이로드의 처음 4 바이트이다.



계약에서 다른 계약을 호출 할 때마다, msg의 모든 속성 값이 새 발신자의 정보를 반영하도록 변경된다. 유일한 예외는 원래 msg 컨텍스트 내에서 다른 계약/라이브러리의 코드를 실행하는 delegatecall 함수이다.



거래 컨텍스트

tx 객체는 거래 관련 정보에 액세스하는 방법을 제공한다.

tx.gasprice

거래를 호출하는데 필요한 가스 가격이다.

tx.origin

이 거래에 대한 원래 EOA의 주소이다. 경고 : 안전하지 않다!



블록 컨텍스트

블록 객체에는 현재 블록에 대한 정보가 포함되어 있다.

block.blockhash(blockNumber)

지정된 블록 번호의 블록 해시이다 (과거 256 블록까지). 더 이상 사용되지 않으며 솔리디티 v0.4.22의 blockhash 함수로 대체되었다.

block.coinbase

현재 블록 수수료 및 보상의 수취인 주소.

block.difficulty

현재 블록의 난이도(작업 증명).

block.gaslimit

현재 블록에 포함 된 모든 거래에 소요될 수 있는 최대 가스량.

block.number

현재 블록 번호(블록 체인 높이).

block.timestamp

채굴자가 현재 블록에 넣은 타임 스탬프(Unix 시대 이후의 초 수).



주소 개체

입력으로 전달되거나 계약 오브젝트에서 형변환되는 모든 주소에는 다음과 같은 많은 속성과 메소드가 있다.

address.balance

wei로 표현된 주소의 잔액. 예를 들어 현재 계약 잔액은 address(this).balance이다.

address.transfer(amount)

Transfers the amount (in wei) to this address, throwing an exception on any error. We used this function in our Faucet example as a method on the msg.sender address, as msg.sender.transfer.

이 주소로 금액 (wei 단위)을 전송하여 오류가 발생할 경우 예외를 발생시킨다. 우리는 msg.sender.transfer와 같이 msg.sender 주소에 대한 메소드로서 파우셋 예제에서 이 함수를 사용했다.

address.send(amount)

Similar to transfer, only instead of throwing an exception, it returns false on error. WARNING: always check the return value of send.

전송과 마찬가지로 예외를 발생하는 대신 오류가 발생하면 false를 반환한다. 경고 : 항상 send의 반환 값을 확인하시오.

address.call(payload)

Low-level CALL function—can construct an arbitrary message call with a data payload. Returns false on error. WARNING: unsafe—recipient can (accidentally or maliciously) use up all your gas, causing your contract to halt with an OOG exception; always check the return value of call.

로우 레벨 CALL  함수 - 데이터 페이로드로 임의의 메시지 호출을 구성 할 수 있다. 오류가 발생하면 false를 반환한다. 경고 : 안전하지 않은 수령인은 (우발적으로 또는 악의적으로) 모든 가스를 다 써서 OOG 예외로 인해 계약이 중단 될 수 있다. 항상 호출의 반환 값을 확인하시오.

address.callcode(payload)

Low-level CALLCODE function, like address(this).call(...) but with this contract’s code replaced with that of address. Returns false on error. WARNING: advanced use only!

address(this).call(...)과 같지만 이 계약의 코드가 주소의 코드로 대체 된 로우 레벨 CALLCODE  함수이다. 오류가 발생하면 false를 반환한다. 경고 : 고급 사용!

address.delegatecall()

Low-level DELEGATECALL function, like callcode(...) but with the full msg context seen by the current contract. Returns false on error. WARNING: advanced use only!

callcode (...)와 같지만 현재 계약에서 볼 수있는 전체 msg 컨텍스트가 있는 로우 레벨 DELEGATECALL 함수이다. 오류가 발생하면 false를 반환한다. 경고 : 고급 사용!



내장 함수

주목할 가치가 있는 다른 기능은 다음과 같다.

addmod, mulmod

모듈로 추가 및 곱하기. 예를 들어 addmod (x, y, k)는 (x + y) % k를 계산한다.

keccak256, sha256, sha3, ripemd160

다양한 표준 해시 알고리즘을 사용하여 해시를 계산하는 함수이다.

ecrecover

서명에서 메시지 서명에 사용 된 주소를 복구한다.

selfdestrunct (__ recipient_address__)

현재 계약을 삭제하고 계정의 나머지 이더를 받는 사람 주소로 보낸다.

this

현재 실행중인 계약 계정의 주소이다.



계약 정의

솔리디티의 주요 데이터 유형은 계약이다. 우리의 파우셋 예제는 단순히 계약 객체를 정의한다. 객체 지향 언어의 객체와 마찬가지로, 계약은 데이터와 메소드가 포함 된 컨테이너이다.

솔리디티는 계약과 유사한 두 가지 다른 오브젝트 유형을 제공한다.

인터페이스(interface)

인터페이스 정의는 계약과 완전히 같은 구조로되어 있지만, 정의 된 함수가 하나도 없다는 것만 제외하면 선언 된 것이다. 이 유형의 선언은 흔히 스텁(stub)이라고 불린다. 어떤 구현도 없이 함수의 인자와 리턴 타입을 알려준다. 인터페이스는 계약의 '모양'을 지정한다. 상속 될 때 인터페이스에 의해 선언 된 각 함수는 자식에 의해 정의되어야한다.

라이브러리(library)

라이브러리 계약은 delegatecall 메소드(주소 오브젝트 참조)를 사용하여 한 번만 배포되고 다른 계약에서 사용되기위한 계약이다.



함수

계약 내에서 EOA 거래나 다른 계약에 의해 호출 될 수 있는 함수를 정의한다. 파우셋 예제에서 우리는 withdraw와(명명되지 않은) 폴백 함수의 두 가지 기능을 가지고 있다.

솔리디티에서 함수를 선언 할 때 사용하는 구문은 다음과 같습니다.

    function FunctionName([parameters]) {public|private|internal|external}
    [pure|constant|view|payable] [modifiers] [returns (return types)]

다음의 각 구성 요소를 살펴보자.

FunctionName

거래(EOA로부터), 다른 계약 또는 동일한 계약 내에서 함수를 호출하는 데 사용되는 함수의 이름. 각 계약의 한 함수는 이름없이 정의 될 수 있다.이 경우 폴백 함수는 다른 함수의 이름이 없을 때 호출됩니다. 폴백 함수는 인수가 없으며 아무 것도 반환 할 수 없다.

parameters

이름 뒤에, 함수 이름과 유형과 함께 전달되어야 하는 인수를 지정한다. 파우셋 예제에서는 uint withdraw_amount를 withdraw 함수의 유일한 인수로 정의했다.
