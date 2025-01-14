module Library.IdrisUtils

import public Data.Maybe
import public Data.Either
import public Data.Contravariant
import public Data.List
import public Data.List.Equalities
import public Data.List.Reverse
import public Data.Nat
import public Data.Nat.Order.Properties
import public Data.Nat.Division
import public Data.Vect
import public Data.Vect.Properties.Foldr
import public Data.HVect
import public Data.Fin
import public Data.DPair
import public Data.Bool
import public Decidable.Decidable
import public Decidable.Equality
import public Control.Function
import public Control.Function.FunExt
import public Control.Relation
import public Control.Order
import public Control.Monad.Identity
import public Control.Monad.Trans
import public Data.Binary
import public Data.Nat.Properties
import public Data.Nat.Exponentiation
import public Data.Binary.Digit
import public Syntax.PreorderReasoning

%default total

infixr 1 |>
public export
(|>) : {0 a, b, c : Type} -> (a -> b) -> (b -> c) -> (a -> c)
(|>) = flip (.)

infixr 1 .*
public export
(.*) : {0 a, b, c, d : Type} -> (c -> d) -> (a -> b -> c) -> (a -> b -> d)
(.*) = (.) . (.)

infixr 1 .**
public export
(.**) : {0 a, b, c, d, e : Type} ->
  (d -> e) -> (a -> b -> c -> d) -> (a -> b -> c -> e)
(.**) = (.) . (.) . (.)

public export
[IdFunctor] Functor Prelude.id where
  map = id

public export
[IdApplicative] Applicative Prelude.id using IdFunctor where
  pure = id
  (<*>) = apply

public export
[IdMonad] Monad Prelude.id using IdApplicative where
  (>>=) = flip apply

public export
[MaybeFunctor] Functor Maybe where
  map f (Just x) = Just (f x)
  map f Nothing  = Nothing

public export
[MaybeApplicative] Applicative Maybe using MaybeFunctor where
  pure = Just
  Just f <*> Just a = Just (f a)
  _      <*> _      = Nothing

public export
[MaybeMonad] Monad Maybe using MaybeApplicative where
  Nothing  >>= k = Nothing
  (Just x) >>= k = k x

public export
[EitherFunctor] Functor (Either a) where
  map f (Left x) = Left x
  map f (Right x) = Right (f x)

public export
[EitherApplicative] Semigroup x =>
    Applicative (Either x) using EitherFunctor where
  pure = Right
  Left f  <*> Left i = Left (f <+> i)
  Left f  <*> Right i = Left f
  Right f <*> Left i = Left i
  Right f <*> Right i = Right (f i)

public export
[EitherMonad] Semigroup x => Monad (Either x) using MaybeApplicative where
  (Left x)  >>= k = Left x
  (Right x) >>= k = k x

public export
fcong : {0 a, b : Type} -> {0 f, g : a -> b} -> (f = g) -> {x : a} -> f x = g x
fcong Refl = Refl

export
mkDPairInjectiveFstHet :
  {0 a, b : Type} -> {0 p : a -> Type} -> {0 q : b -> Type} ->
  {x : a} -> {y : b} -> {f : p x} -> {g : q y} ->
  MkDPair {a} {p} x f = MkDPair {a=b} {p=q} y g -> x = y
mkDPairInjectiveFstHet Refl = Refl

export
mkDPairInjectiveSndHet :
  {0 a, b : Type} -> {0 p : a -> Type} -> {0 q : b -> Type} ->
  {x : a} -> {y : b} -> {f : p x} -> {g : q y} ->
  (dpeq : MkDPair {a} {p} x f = MkDPair {a=b} {p=q} y g) ->
  f ~=~ g
mkDPairInjectiveSndHet Refl = Refl

public export
maybeElim : {0 a, b : Type} -> (a -> b) -> b -> Maybe a -> b
maybeElim f g (Just e) = f e
maybeElim f g Nothing = g

public export
eitherElim : {0 a, b, c : Type} -> (a -> c) -> (b -> c) -> Either a b -> c
eitherElim f g (Left e) = f e
eitherElim f g (Right e) = g e

public export
codiag : {0 a : Type} -> Either a a -> a
codiag {a} = eitherElim {a} {b=a} {c=a} id id

-- Like Idris's standard `Subset`, but with even the `pred` type
-- parameter erased.
public export
record Subset0 (type : Type) (0 dep : type -> Type) where
  constructor Element0
  fst0 : type
  0 snd0 : dep fst0

public export
curry : {0 p : a -> Type} -> (Subset0 a p -> c) -> (x : a) -> (0 _ : p x) -> c
curry f x y = f $ Element0 x y

public export
uncurry : {0 p : a -> Type} -> ((x : a) -> (0 _ : p x) -> c) -> Subset0 a p -> c
uncurry f s = f s.fst0 s.snd0

export
elementInjectiveFst : Element0 x p = Element0 y q -> x = y
elementInjectiveFst Refl = Refl

export
elementInjectiveSnd : Element0 x p = Element0 x q -> p = q
elementInjectiveSnd Refl = Refl

public export
bimap : (f : a -> b) -> (0 _ : forall x. p x -> q (f x)) ->
  Subset0 a p -> Subset0 b q
bimap f g (Element0 x y) = Element0 (f x) (g y)

public export
Eq type => Eq (Subset0 type dep) where
  (==) = (==) `on` fst0

public export
Ord type => Ord (Subset0 type dep) where
  compare = compare `on` fst0

public export
Show type => Show (Subset0 type dep) where
  show = show . fst0

-- Like Idris's standard `Exists`, but with the `this` dependent type
-- taking a zero-usage type parameter.
public export
record Exists0 (0 type : Type) (this : (0 _ : type) -> Type) where
  constructor Evidence0
  0 fst0 : type
  snd0 : this fst0

public export
const0 : {0 a, b : Type} -> b -> (0 _ : a) -> b
const0 x _ = x

-- Non-dependent `Exists0`.
public export
CExists0 : (0 a: Type) -> Type -> Type
CExists0 a b = Exists0 a (const0 b)

public export
DecNonZero : (n : Nat) -> Dec (NonZero n)
DecNonZero Z = No $ \nzz => case nzz of SIsNonZero impossible
DecNonZero (S n) = Yes SIsNonZero

public export
divMaybe : Nat -> Nat -> Maybe Nat
divMaybe n m with (DecNonZero m)
  divMaybe n m | Yes nz = Just $ divNatNZ n m nz
  divMaybe n m | No _ = Nothing

public export
modMaybe : Nat -> Nat -> Maybe Nat
modMaybe n m with (DecNonZero m)
  modMaybe n m | Yes nz = Just $ modNatNZ n m nz
  modMaybe n m | No _ = Nothing

public export
divWithZtoZ : Integer -> Integer -> Integer
divWithZtoZ n m = if m == 0 then 0 else div n m

public export
modWithZtoZ : Integer -> Integer -> Integer
modWithZtoZ n m = if m == 0 then 0 else mod n m

public export
divSucc : Integer -> Integer -> Integer
divSucc n m = div n (m + 1)

public export
modSucc : Integer -> Integer -> Integer
modSucc n m = mod n (m + 1)

public export
boolToDigit : Bool -> Digit
boolToDigit True = I
boolToDigit False = O

public export
exfalsoFT : {0 a : Type} -> (0 ft : False = True) -> a
exfalsoFT Refl impossible

public export
exfalsoTF : {0 a : Type} -> (0 tf : True = False) -> a
exfalsoTF Refl impossible

public export
uip : {0 a : Type} -> {0 x, x' : a} -> {eq, eq' : x = x'} -> eq = eq'
uip {eq=Refl} {eq'=Refl} = Refl

public export
lteTolt : {m, n : Nat} -> LTE m n -> Not (m = n) -> LT m n
lteTolt {m=0} {n=Z} LTEZero neq = void $ neq Refl
lteTolt {m=0} {n=(S n)} LTEZero neq = LTESucc LTEZero
lteTolt {m=(S m)} {n=(S n)} (LTESucc x) neq =
  LTESucc $ lteTolt {m} {n} x (\eq => case eq of Refl => neq Refl)

public export
lteAddLeft : (m, n : Nat) -> LTE n (m + n)
lteAddLeft m n = rewrite plusCommutative m n in lteAddRight {m} n

public export
compareNatSucc : (n : Nat) -> compareNat n (S n) = LT
compareNatSucc Z = Refl
compareNatSucc (S n) = compareNatSucc n

public export
lteZeroIsZero : {n : Nat} -> LTE n 0 -> 0 = n
lteZeroIsZero {n=Z} _ = Refl
lteZeroIsZero {n=(S _)} lt = void $ succNotLTEzero lt

public export
lteSuccEitherEqLte : {m, n : Nat} -> LTE m (S n) -> Either (m = S n) (LTE m n)
lteSuccEitherEqLte {m} {n} lte with (decEq m (S n))
  lteSuccEitherEqLte {m} {n} lte | Yes eq =
    Left eq
  lteSuccEitherEqLte {m} {n} lte | No neq =
    Right $ fromLteSucc $ lteTolt lte neq

public export
maxLTE : {m, n, k : Nat} -> LTE m k -> LTE n k -> LTE (maximum m n) k
maxLTE {m=Z} {n} {k} ltmk ltnk = ltnk
maxLTE {m=(S m)} {n=Z} {k} ltmk ltnk = ltmk
maxLTE {m=(S m)} {n=(S n)} {k=Z} ltmk ltnk = void $ succNotLTEzero ltmk
maxLTE {m=(S m)} {n=(S n)} {k=(S k)} ltmk ltnk =
  LTESucc $ maxLTE {m} {n} {k} (fromLteSucc ltmk) (fromLteSucc ltnk)

public export
maxLTELeft : (m, n : Nat) -> LTE m (maximum m n)
maxLTELeft = maximumLeftUpperBound

public export
maxLTERight : (m, n : Nat) -> LTE n (maximum m n)
maxLTERight = maximumRightUpperBound

public export
smax : Nat -> Nat -> Nat
smax = S .* maximum

public export
smaxLTLeft : (m, n : Nat) -> LT m (smax m n)
smaxLTLeft m n = LTESucc $ maxLTELeft m n

public export
smaxLTRight : (m, n : Nat) -> LT n (smax m n)
smaxLTRight m n = LTESucc $ maxLTERight m n

public export
smaxLTMax : (m, n : Nat) -> LT (maximum m n) (smax m n)
smaxLTMax m n = LTESucc reflexive

public export
voidF : (0 a : Type) -> Void -> a
voidF _ x = void x

public export
IsTrue : Bool -> Type
IsTrue b = b = True

public export
IsFalse : Bool -> Type
IsFalse b = b = False

public export
IsJustTrue : {a : Type} -> Maybe a -> Type
IsJustTrue x = isJust x = True

public export
IsNothingTrue : {a : Type} -> Maybe a -> Type
IsNothingTrue x = isJust x = False

public export
andLeft : {p, q : Bool} -> IsTrue (p && q) -> IsTrue p
andLeft {p=True} {q=True} Refl = Refl
andLeft {p=True} {q=False} Refl impossible
andLeft {p=False} {q=True} Refl impossible
andLeft {p=False} {q=False} Refl impossible

public export
andRight : {p, q : Bool} -> IsTrue (p && q) -> IsTrue q
andRight {p=True} {q=True} Refl = Refl
andRight {p=True} {q=False} Refl impossible
andRight {p=False} {q=True} Refl impossible
andRight {p=False} {q=False} Refl impossible

public export
repeatIdx : {0 x : Type} -> (Nat -> x -> x) -> Nat -> Nat -> x -> x
repeatIdx f Z i e = e
repeatIdx f (S n) i e = repeatIdx f n (S i) (f i e)

public export
repeat : {0 x : Type} -> (x -> x) -> Nat -> x -> x
repeat f Z e = e
repeat f (S n) e = repeat f n (f e)

public export
fromIsJust : {a : Type} -> {x : Maybe a} -> IsJustTrue x -> a
fromIsJust {x=(Just x)} Refl = x
fromIsJust {x=Nothing} Refl impossible

public export
IsYesTrue : {a : Type} -> Dec a -> Type
IsYesTrue x = isYes x = True

public export
fromIsYes : {a : Type} -> {x : Dec a} -> IsYesTrue x -> a
fromIsYes {x=(Yes x)} Refl = x
fromIsYes {x=(No n)} Refl impossible

public export
toIsYes : {a : Type} -> (x : a) -> {dx : Dec a} -> IsYesTrue dx
toIsYes x {dx=(Yes y)} = Refl
toIsYes x {dx=(No n)} = void $ n x

public export
fstEq : {a, b : Type} -> {x, y : (a, b)} -> x = y -> fst x = fst y
fstEq Refl = Refl

public export
sndEq : {a, b : Type} -> {x, y : (a, b)} -> x = y -> snd x = snd y
sndEq Refl = Refl

public export
fromLteSuccYes : {m, n : Nat} ->
  IsYesTrue (isLT (S m) (S n)) -> IsYesTrue (isLT m n)
fromLteSuccYes y = toIsYes (fromLteSucc $ fromIsYes y)

public export
finToNatLT : {m : Nat} -> (i : Fin m) -> LT (finToNat i) m
finToNatLT {m=Z} i = absurd i
finToNatLT {m=(S m)} FZ = LTESucc LTEZero
finToNatLT {m=(S m)} (FS i) = LTESucc $ finToNatLT {m} i

public export
indexN : {0 a : Type} -> {n : Nat} ->
  (i : Nat) -> {auto ok : IsJustTrue (natToFin i n)} -> Vect n a -> a
indexN _ {ok} = index (fromIsJust ok)

public export
indexNL : {0 a : Type} -> {n : Nat} ->
  (i : Nat) -> {auto ok : IsYesTrue (isLT i n)} -> Vect n a -> a
indexNL i {ok} v = index (natToFinLT i {prf=(fromIsYes ok)}) v

public export
natToFinLTS : {m, n : Nat} -> {lt : LT m n} -> {ltS : LT (S m) n'} ->
  natToFinLT {n=(S n)} (S m) = FS (natToFinLT {n} m)
natToFinLTS = Refl

public export
indexToFinS : {a : Type} -> {m, n : Nat} ->
  {ltS : LT (S m) (S n)} -> {lt : LT m n} ->
  {x : a} -> {v : Vect n a} ->
  index (natToFinLT (S m)) (x :: v) = index (natToFinLT m) v
indexToFinS {a} {m} {n=Z} {ltS} {lt} {x} {v} = void $ succNotLTEzero lt
indexToFinS {a} {m=Z} {n=(S n)} {ltS} {lt=LTEZero} {x} {v} impossible
indexToFinS {a} {m=Z} {n=(S n)} {ltS=LTEZero} {lt} {x} {v} impossible
indexToFinS {a} {m=Z} {n=(S n)} {ltS=(LTESucc ltS)} {lt=(LTESucc lt)} {x} {v} =
  case ltS of
    LTEZero impossible
    LTESucc ltS' => Refl
indexToFinS {a} {m=(S m)} {n=(S n)} {ltS=LTEZero} {lt} {x} {v} impossible
indexToFinS {a} {m=(S m)} {n=(S n)} {ltS} {lt=LTEZero} {x} {v} impossible
indexToFinS {a} {m=(S m)} {n=(S n)}
  {ltS=(LTESucc ltS)} {lt=(LTESucc lt)} {x} {v} =
    case v of
      [] impossible
      (x' :: v') => indexToFinS {m} {n} {ltS} {lt} {x=x'} {v=v'}

public export
indexToFinLTS : {a : Type} -> {n : Nat} ->
  {i : Nat} ->
  {auto okS : IsYesTrue (isLT (S i) (S n))} ->
  {auto ok : IsYesTrue (isLT i n)} ->
  {x : a} -> {v : Vect n a} ->
  indexNL (S i) {ok=okS} (x :: v) = indexNL i {ok} v
indexToFinLTS {n} {i} {okS} {ok} {x} {v} =
  indexToFinS {a} {m=i} {n=n} {ltS=(fromIsYes okS)} {lt=(fromIsYes ok)} {x} {v}

public export
finFTail : {0 a : Type} -> {n : Nat} -> (Fin (S n) -> a) -> (Fin n -> a)
finFTail {a} {n} f = f . FS

public export
finFToVectOnto : {0 a : Type} -> {m, n : Nat} ->
  (Fin m -> a) -> Vect n a -> Vect (m + n) a
finFToVectOnto {a} {m=Z} {n} f v = v
finFToVectOnto {a} {m=(S m)} {n} f v =
  rewrite plusSuccRightSucc m n in
  finFToVectOnto {a} {m} {n=(S n)} (finFTail f) (f FZ :: v)

public export
finFToVectTR : {0 a : Type} -> {m : Nat} -> (Fin m -> a) -> Vect m a
finFToVectTR {a} {m} f =
  rewrite sym (plusZeroRightNeutral m) in
  reverse $ finFToVectOnto {a} {m} {n=Z} f []

public export
finFToVect : {0 a : Type} -> {n : Nat} -> (Fin n -> a) -> Vect n a
finFToVect {a} {n=Z} f = []
finFToVect {a} {n=(S n)} f = f FZ :: finFToVect {n} (f . FS)

public export
finHFToHVect : {n : Nat} -> {t : Fin n -> Type} -> ((i : Fin n) -> t i) ->
  HVect (finFToVect t)
finHFToHVect {n=Z} {t} f = []
finHFToHVect {n=(S n)} {t} f = f FZ :: finHFToHVect {n} (\i => f (FS i))

public export
finFGet : {0 n : Nat} ->
  (i : Fin n) -> {f : Fin n -> Type} -> HVect (finFToVect f) -> f i
finFGet {n=Z} i {f} [] = absurd i
finFGet {n=(S n)} FZ {f} (ty :: hv) = ty
finFGet {n=(S n)} (FS i) {f} (ty :: hv) = finFGet {n} i {f=(f . FS)} hv

public export
vectRepeat : (a : Nat) -> {b, c : Nat} ->
  Vect b (Fin c) -> Vect (mult a b) (Fin c)
vectRepeat Z {b} {c} v = []
vectRepeat (S a) {b} {c} v = v ++ vectRepeat a {b} {c} v

public export
vectMaxAcc : {0 n : Nat} -> Nat -> Vect n Nat -> Nat
vectMaxAcc m [] = m
vectMaxAcc m (x :: xs) = vectMaxAcc (maximum m x) xs

public export
vectMax : {0 n : Nat} -> Vect n Nat -> Nat
vectMax = vectMaxAcc 0

public export
0 maximumMonotoneRight : (x, m, m' : Nat) -> LTE m m' ->
  LTE (maximum x m) (maximum x m')
maximumMonotoneRight Z m m' lte = lte
maximumMonotoneRight (S x) Z m' lte = maximumLeftUpperBound (S x) m'
maximumMonotoneRight (S x) (S m) Z lte = void $ succNotLTEzero lte
maximumMonotoneRight (S x) (S m) (S m') (LTESucc lte) =
  LTESucc $ maximumMonotoneRight x m m' lte

public export
0 maximumMonotoneLeft : (m, m', x : Nat) -> LTE m m' ->
  LTE (maximum m x) (maximum m' x)
maximumMonotoneLeft m m' x lte =
  rewrite maximumCommutative m x in
  rewrite maximumCommutative m' x in
  maximumMonotoneRight x m m' lte

public export
0 vectMaxGetAccMonotoneMax : {n : Nat} -> (m : Nat) -> (v : Vect n Nat) ->
  LTE m (vectMaxAcc {n} m v)
vectMaxGetAccMonotoneMax {n=Z} m [] = reflexive
vectMaxGetAccMonotoneMax {n=(S n)} m (x :: xs) =
  transitive
    (maximumLeftUpperBound m x)
    (vectMaxGetAccMonotoneMax {n} (maximum m x) xs)

public export
0 vectMaxGetAccMonotoneVect : {n : Nat} -> (m, m' : Nat) -> (v : Vect n Nat) ->
  LTE m m' -> LTE (vectMaxAcc {n} m v) (vectMaxAcc {n} m' v)
vectMaxGetAccMonotoneVect {n=Z} m m' [] lte = lte
vectMaxGetAccMonotoneVect {n=(S n)} m m' (x :: xs) lte =
  vectMaxGetAccMonotoneVect
    {n} (maximum m x) (maximum m' x) xs (maximumMonotoneLeft m m' x lte)

public export
0 vectMaxGetAccBoundHead : {n : Nat} -> (m : Nat) ->
  (x : Nat) -> (v : Vect n Nat) ->
  LTE x (vectMaxAcc {n=(S n)} m (x :: v))
vectMaxGetAccBoundHead {n} m x v =
  transitive
    (maximumRightUpperBound m x)
    (vectMaxGetAccMonotoneMax {n} (maximum m x) v)

public export
0 vectMaxGetAccBoundTail : {n : Nat} -> (m : Nat) ->
  (x : Nat) -> (v : Vect n Nat) ->
  LTE (vectMaxAcc {n} m v) (vectMaxAcc {n=(S n)} m (x :: v))
vectMaxGetAccBoundTail {n} m x v =
  vectMaxGetAccMonotoneVect {n} m (maximum m x) v (maximumLeftUpperBound m x)

public export
0 vectMaxGetAccCorrect : {n : Nat} -> (m : Nat) -> (v : Vect n Nat) ->
  (i : Fin n) -> LTE (index i v) (vectMaxAcc m v)
vectMaxGetAccCorrect {n=Z} m [] i = absurd i
vectMaxGetAccCorrect {n=(S n)} m (x :: xs) FZ =
  vectMaxGetAccBoundHead {n} m x xs
vectMaxGetAccCorrect {n=(S n)} m (x :: xs) (FS i) =
  transitive
    (vectMaxGetAccCorrect {n} m xs i)
    (vectMaxGetAccBoundTail {n} m x xs)

public export
vectMaxGetAcc : {0 n : Nat} ->
  (0 m : Nat) -> (v : Vect n Nat) -> Fin n -> Fin (S (vectMaxAcc m v))
vectMaxGetAcc {n} m v i =
  natToFinLT
    {n=(S (vectMaxAcc m v))}
    {prf=(LTESucc $ vectMaxGetAccCorrect {n} m v i)}
    (index i v)

public export
vectMaxGet : {0 n : Nat} -> (v : Vect n Nat) -> Fin n -> Fin (S (vectMax v))
vectMaxGet {n} v i = vectMaxGetAcc {n} 0 v i

public export
powerOneIsOne : (n : Nat) -> power 1 n = 1
powerOneIsOne Z = Refl
powerOneIsOne (S n) = rewrite powerOneIsOne n in Refl

public export
finPlus : {m, n : Nat} -> Fin m -> Fin n -> Fin (m + n)
finPlus {m=Z} {n} FZ j impossible
finPlus {m=(S m)} {n} FZ j =
  rewrite plusCommutative m n in
  rewrite plusSuccRightSucc n m in
  weakenN (S m) j
finPlus {m=(S m)} {n} (FS i) j = FS $ finPlus i j

public export
finMul : (m, n : Nat) -> Fin m -> Fin (S n * m)
finMul Z n i = absurd i
finMul (S m) Z i = rewrite plusZeroRightNeutral (S m) in i
finMul (S m) (S n) i =
  weaken $ replace {p=Fin} (plusCommutative (mult (S n) (S m)) m) $
    weakenN m $ finMul (S m) n i

public export
finPow : (m, n : Nat) -> Fin m -> Fin (power m n)
finPow m Z i = FZ
finPow Z (S n) i = absurd i
finPow (S Z) (S n) FZ = rewrite powerOneIsOne n in FZ
finPow (S (S m)) (S n) i =
  let fp = finPow (S (S m)) n i in
  finPlus fp $ finMul _ m fp

public export
finMulFin : {m, n : Nat} -> Fin m -> Fin n -> Fin (m * n)
finMulFin {m=Z} {n} i j = absurd i
finMulFin {m} {n=Z} i j = absurd j
finMulFin {m=(S m)} {n=(S n)} FZ j = FZ
finMulFin {m=(S m)} {n=(S n)} (FS i) FZ = FZ
finMulFin {m=(S m)} {n=(S n)} (FS i) (FS j) =
  rewrite multRightSuccPlus m n in
  -- (1 + i) * (1 + j) = 1 + j + i + i * j
  FS $ finPlus j $ finPlus i $ finMulFin {m} {n} i j

public export
finPowFin : {m, n : Nat} -> Vect m (Fin n) -> Fin (power n m)
finPowFin {m=Z} {n} [] = FZ
finPowFin {m=(S m)} {n} (x :: v) = finMulFin x $ finPowFin {m} {n} v

public export
foldrNat : (a -> a) -> a -> Nat -> a
foldrNat f acc Z = acc
foldrNat f acc (S n) = foldrNat f (f acc) n

public export
foldrNatNoUnit : (a -> a) -> a -> a -> Nat -> a
foldrNatNoUnit f unit acc Z = unit
foldrNatNoUnit f unit acc (S n) = foldrNat f acc n

public export
collectPairsAcc : List Nat -> List (Nat, Nat) -> List (Nat, Nat)
collectPairsAcc [] acc = acc
collectPairsAcc (n :: ns) [] = collectPairsAcc ns [(n, 1)]
collectPairsAcc (n :: ns) ps@((n', c) :: ps') =
  if n == n' then
    collectPairsAcc ns ((n', S c) :: ps')
  else
    collectPairsAcc ns $ (n, 1) :: ps

public export
collectPairs : List Nat -> List (Nat, Nat)
collectPairs l = collectPairsAcc l []

public export
equalNatCorrect : {m : Nat} -> equalNat m m = True
equalNatCorrect {m=Z} = Refl
equalNatCorrect {m=(S m')} = equalNatCorrect {m=m'}

public export
foldAppendExtensional : {0 a : Type} -> {n : Nat} ->
  (l : List a) -> (v : Vect n a) ->
  foldrImpl (::) [] ((++) l) v = l ++ foldrImpl (::) [] (id {a=(List a)}) v
foldAppendExtensional {a} {n} l v = ?foldAppendExtensional_hole

public export
foldLengthAppend : {0 a : Type} -> {n : Nat} ->
  (l : List a) -> (v : Vect n a) ->
  List.length (foldrImpl (::) [] ((++) l) v) =
    length l + (List.length (foldrImpl (::) [] (id {a=(List a)}) v))
foldLengthAppend {a} {n} l v =
  let h = foldrVectHomomorphism in
  trans
    ?foldLengthAppend_hole
    (lengthDistributesOverAppend _ _)

public export
toListLength : {n : Nat} -> {0 a : Type} ->
  (v : Vect n a) -> length (toList v) = n
toListLength {n=Z} {a} [] = Refl
toListLength {n=(S n)} {a} (x :: v) =
  trans (foldLengthAppend [x] v) (cong S $ toListLength {n} {a} v)

public export
predLen : {0 a : Type} -> List a -> Nat
predLen = pred . length

public export
powerZeroOne : (0 n : Nat) -> power n 0 = 1
powerZeroOne n = Refl

public export
powerOneOne : (n : Nat) -> power 1 n = 1
powerOneOne Z = Refl
powerOneOne (S n) = rewrite powerOneOne n in Refl

public export
mulPowerZeroRightNeutral : {0 m, n : Nat} -> m * (power n 0) = m
mulPowerZeroRightNeutral {m} {n} = rewrite multOneRightNeutral m in Refl

public export
powerOfSum : (x, y, z : Nat) -> power x (y + z) = power x y * power x z
powerOfSum x Z z = rewrite plusZeroRightNeutral (power x z) in Refl
powerOfSum x (S y) z =
  trans (cong (mult x) (powerOfSum x y z)) $
    multAssociative x (power x y) (power x z)

public export
mulToPower : (x, y, z : Nat) -> power (x * y) z = power x z * power y z
mulToPower x y Z = Refl
mulToPower x y (S z) =
  rewrite mulToPower x y z in
  rewrite sym (multAssociative x y (mult (power x z) (power y z))) in
  rewrite sym (multAssociative x (power x z) (mult y (power y z))) in
  cong (mult x) $
    trans
      (trans
        (multAssociative y (power x z) (power y z))
        (rewrite multCommutative y (power x z) in Refl))
      (sym $ multAssociative (power x z) y (power y z))

public export
powerOfMul : (x, y, z : Nat) -> power x (y * z) = power (power x y) z
powerOfMul x Z z = sym (powerOneOne z)
powerOfMul x (S y) Z = rewrite multZeroRightZero y in Refl
powerOfMul x (S y) (S z) =
  rewrite powerOfSum x (S z) (y * (S z)) in
  rewrite multRightSuccPlus y z in
  rewrite powerOfSum x y (y * z) in
  rewrite sym
    (multAssociative x (power x z) (mult (power x y) (power x (mult y z)))) in
  rewrite sym (multAssociative x (power x y) (power (mult x (power x y)) z)) in
  rewrite powerOfMul x y z in
  rewrite multAssociative (power x z) (power x y) (power (power x y) z) in
  rewrite multCommutative (power x z) (power x y) in
  rewrite sym (multAssociative (power x y) (power x z) (power (power x y) z)) in
  cong (mult x) $ cong (mult (power x y)) $
    sym $ mulToPower x (power x y) z

public export
powerOfMulSym : (x, y, z : Nat) -> power x (y * z) = power (power x z) y
powerOfMulSym x y z = rewrite multCommutative y z in powerOfMul x z y

public export
LTEReflectsLte : {k, n : Nat} -> k `LTE` n -> lte k n = True
LTEReflectsLte LTEZero = Refl
LTEReflectsLte (LTESucc lte) = LTEReflectsLte lte

public export
notLTEReflectsLte : {k, n : Nat} -> Not (k `LTE` n) -> lte k n = False
notLTEReflectsLte nlte with (lte k n) proof ltekn
  notLTEReflectsLte nlte | True = void $ nlte $ lteReflectsLTE _ _ ltekn
  notLTEReflectsLte nlte | False = Refl

public export
notLteReflectsLTE : {k, n : Nat} -> lte k n = False -> Not (k `LTE` n)
notLteReflectsLTE nlte with (isLTE k n)
  notLteReflectsLTE nlte | Yes yLTE =
    case trans (sym nlte) (LTEReflectsLte yLTE) of Refl impossible
  notLteReflectsLTE nlte | No notLTE = notLTE

public export
gteTogt : {m, n : Nat} -> Not (LTE (S m) n) -> Not (m = n) -> Not (LT m (S n))
gteTogt {m} {n=Z} gt neq (LTESucc lte) = neq $ sym (lteZeroIsZero lte)
gteTogt {m=Z} {n=(S n)} gt neq (LTESucc lte) = gt $ LTESucc LTEZero
gteTogt {m=(S m)} {n=(S n)} gt neq (LTESucc lte) =
  gt $ LTESucc $ lteTolt (fromLteSucc lte) $ \ eqmn => neq $ cong S eqmn

public export
mod'Z : (m : Nat) -> mod' m m Z = Z
mod'Z Z = Refl
mod'Z (S m) = rewrite minusZeroRight m in mod'Z m

public export
div'One : (k : Nat) -> div' k k 0 = k
div'One Z = Refl
div'One (S k) = rewrite minusZeroRight k in cong S (div'One k)

public export
div'LT : (k, k' : Nat) -> LTE (div' k k' 0) k
div'LT Z Z = LTEZero
div'LT (S k) Z = LTEZero
div'LT Z (S k') = LTEZero
div'LT (S k) (S k') = LTESucc $ rewrite minusZeroRight k' in div'LT k k'

public export
divMinusMono : (fuel, k, n : Nat) ->
  lte k n = False -> LT (div' fuel (minus k (S n)) n) (div' (S fuel) k n)
divMinusMono fuel k n gtkn = rewrite gtkn in reflexive

public export
lteToDiff : {m, n : Nat} -> LTE m n -> (k : Nat ** k + m = n)
lteToDiff {m} {n} lte = (minus n m ** plusMinusLte m n lte)

public export
diffToLte : {m, n, k : Nat} -> k + m = n -> LTE m n
diffToLte {m} {k=Z} Refl = reflexive
diffToLte {m} {n} {k=(S k)} pleq =
  lteSuccLeft $ diffToLte {m=(S m)} {n} {k} $
    rewrite sym (plusSuccRightSucc k m) in
    pleq

public export
multDivLTLemma : (k, m, n, diffmsnsk : Nat) ->
  diffmsnsk + S k = m * S n ->
  (diffmdivksn : Nat ** diffmdivksn + S (divNatNZ k (S n) SIsNonZero) = m)
multDivLTLemma k m n diffmsnsk diffmsnskeq = ?multDivLTLemma_hole

public export
multDivLT : {k, m, n : Nat} ->
  LT k (m * n) -> (nz : NonZero n) -> LT (divNatNZ k n nz) m
multDivLT {k} {m} {n=(S n)} lt SIsNonZero =
  let
    (diffmsnsk ** diffmsnskeq) = lteToDiff lt
    (diffmdivksn ** diffmdivksneq) = multDivLTLemma k m n diffmsnsk diffmsnskeq
  in
  diffToLte
    {m=(S (divNatNZ k (S n) SIsNonZero))} {n=m} {k=diffmdivksn} diffmdivksneq

public export
multAddLT : {k, m, n, p : Nat} ->
  LT k n -> LT m p -> LT (p * k + m) (n * p)
multAddLT {k} {m} {n=Z} {p} ltkn ltmp = void $ succNotLTEzero ltkn
multAddLT {k} {m} {n=(S n)} {p=Z} ltkn ltmp = void $ succNotLTEzero ltmp
multAddLT {k} {m} {n=(S n)} {p=(S p)} (LTESucc ltkn) (LTESucc ltmp) =
  LTESucc $
    rewrite multRightSuccPlus n p in
    rewrite plusCommutative p (plus n (mult n p)) in
    let mpk = multCommutative k p in
    plusLteMonotone
      (plusLteMonotone ltkn $
        replace {p=(\q => LTE q (n * p))} mpk $ multLteMonotoneLeft _ _ _ ltkn)
      ltmp

public export
modLTDivisor : (m, n : Nat) -> LT (modNatNZ m (S n) SIsNonZero) (S n)
modLTDivisor m n = boundModNatNZ m (S n) SIsNonZero

public export
modLtDivisor : (m, n : Nat) -> IsTrue $ gt (S n) $ modNatNZ m (S n) SIsNonZero
modLtDivisor m n = LTEReflectsLte $ fromLteSucc $ modLTDivisor m n

public export
minusModulo : (modulus, m, n : Integer) -> Integer
minusModulo modulus m n =
  if modulus == 0 then
    0
  else
    if m >= n then
      mod (m - n) modulus
    else
      let r = mod (n - m) modulus in
      if r == 0 then 0 else modulus - r

public export
magmaFromNonEmptyList : {a : Type} -> (a -> a -> a) -> a -> List a -> a
magmaFromNonEmptyList f x [] = x
magmaFromNonEmptyList f x (x' :: l) = f x $ magmaFromNonEmptyList f x' l

public export
monoidFromList : {a : Type} -> a -> (a -> a -> a) -> List a -> a
monoidFromList id compose [] = id
monoidFromList id compose (x :: l) = magmaFromNonEmptyList compose x l

public export
pairInj1 : {a, b : Type} -> {p, p' : (a, b)} -> p = p' -> fst p = fst p'
pairInj1 Refl = Refl

public export
pairInj2 : {a, b : Type} -> {p, p' : (a, b)} -> p = p' -> snd p = snd p'
pairInj2 Refl = Refl

public export
DecEqPred : (a: Type) -> Type
DecEqPred a = (x, x': a) -> Dec (x = x')

export
encodingDecEq : {a, b : Type} ->
  (encode : a -> b) -> (decode : b -> Maybe a) ->
  (encodingIsCorrect : (x : a) -> decode (encode x) = Just x) ->
  (bDecEq : DecEqPred b) ->
  DecEqPred a
encodingDecEq encode decode encodingIsCorrect bDecEq x x' with
  (bDecEq (encode x) (encode x'))
    encodingDecEq encode decode encodingIsCorrect bDecEq x x' | Yes eq = Yes $
      injective $
        trans
          (sym (encodingIsCorrect x))
          (trans
            (cong decode eq)
            (encodingIsCorrect x'))
    encodingDecEq encode decode encodingIsCorrect bDecEq x x' | No neq =
      No $ \xeq => neq $ cong encode xeq

public export
finEncodingDecEq : {a : Type} -> {size : Nat} ->
  (encode : a -> Fin size) -> (decode : Fin size -> a) ->
  (encodingIsCorrect : (x : a) -> decode (encode x) = x) ->
  DecEqPred a
finEncodingDecEq {a} {size} encode decode encodingIsCorrect =
  encodingDecEq {a} {b=(Fin size)}
    encode (Just . decode) (\x => rewrite encodingIsCorrect x in Refl) decEq

public export
finDecPred : {n : Nat} -> (p : Fin n -> Type) -> ((x : Fin n) -> Dec (p x)) ->
  Dec ((x : Fin n) -> p x)
finDecPred {n=Z} p d = Yes $ \x => case x of _ impossible
finDecPred {n=(S n)} p d =
  case d FZ of
    Yes yes => case finDecPred {n} (p . FS) (\x => d $ FS x) of
      Yes yes' => Yes $ \x => case x of
        FZ => yes
        FS x' => yes' x'
      No no' => No $ \yes' => no' $ \x => yes' $ FS x
    No no => No $ \yes => no $ yes FZ

public export
FinDecoder : Type -> Nat -> Type
FinDecoder a size = Fin size -> a

public export
FinEncoder : {a : Type} -> {size : Nat} -> FinDecoder a size -> Type
FinEncoder {a} {size} decoder = (e : a) -> (x : Fin size ** decoder x = e)

public export
FinDecEncoding : (a : Type) -> (size : Nat) -> Type
FinDecEncoding a size = DPair (FinDecoder a size) FinEncoder

public export
fdeEq : {0 a : Type} -> {n : Nat} -> FinDecEncoding a n -> a -> a -> Bool
fdeEq enc x x' = fst (snd enc x) == fst (snd enc x')

public export
(a : Type) => (n : Nat) => (enc : FinDecEncoding a n) => Eq a where
  (==) = fdeEq {a} {n} enc

public export
fdeLt : {0 a : Type} -> {n : Nat} -> FinDecEncoding a n -> a -> a -> Bool
fdeLt enc x x' = fst (snd enc x) < fst (snd enc x')

public export
(a : Type) => (n : Nat) => (enc : FinDecEncoding a n) => Ord a where
  (<) = fdeLt {a} {n} enc

public export
fdeDecEq : {0 a : Type} -> {n : Nat} -> FinDecEncoding a n -> DecEqPred a
fdeDecEq (decode ** encode) e e' =
  case (decEq (fst $ encode e) (fst $ encode e')) of
    Yes eq => Yes $
      trans (sym (snd $ encode e)) (trans (cong decode eq) (snd $ encode e'))
    No neq => No $ \yes => neq $ case yes of Refl => Refl

public export
(a : Type) => (n : Nat) => (enc : FinDecEncoding a n) => DecEq a where
  decEq = fdeDecEq {a} {n} enc

public export
FDEnc : Type -> Type
FDEnc = DPair Nat . FinDecEncoding

public export
ListContains : {a : Type} -> List a -> a -> Type
ListContains [] x = Void
ListContains (x :: xs) x' = Either (x = x') (ListContains xs x')

public export
listContainsDec : {a : Type} -> DecEqPred a -> (l : List a) -> (x : a) ->
  Dec (ListContains l x)
listContainsDec deq [] x = No $ \v => void v
listContainsDec deq (x :: xs) x' =
  case deq x x' of
    Yes Refl => Yes $ Left Refl
    No neqx => case listContainsDec deq xs x' of
      Yes c => Yes $ Right c
      No nc => No $ \yes => case yes of
        Left eqx => neqx eqx
        Right c => nc c

public export
ListContainsTrue : {a : Type} -> DecEqPred a -> (l : List a) -> (x : a) -> Type
ListContainsTrue deq l x = IsYesTrue $ listContainsDec deq l x

public export
ListContainsTrueUIP : {a : Type} ->
  (deq : DecEqPred a) -> (l : List a) -> (x : a) ->
  (c, c' : ListContainsTrue deq l x) ->
  c = c'
ListContainsTrueUIP deq l x c c' = uip

public export
ListMember : {a : Type} -> List a -> Type
ListMember {a} l = Subset0 a (ListContains l)

public export
ListMemberDec : {a : Type} -> DecEqPred a -> List a -> Type
ListMemberDec {a} deq l = Subset0 a (ListContainsTrue deq l)

public export
ListMemberDecInj : {a : Type} ->
  (deq : DecEqPred a) -> (l : List a) -> (m, m' : ListMemberDec deq l) ->
  fst0 m = fst0 m' -> m = m'
ListMemberDecInj {a} deq l (Element0 x c) (Element0 x' c') eq =
  case eq of
    Refl => rewrite ListContainsTrueUIP deq l x c c' in Refl

public export
FinSubEncoding : Type -> Nat -> Type
FinSubEncoding a size = (FinDecEncoding a size, List a)

public export
fseEnc : {a : Type} -> {n : Nat} -> FinSubEncoding a n -> FinDecEncoding a n
fseEnc = fst

public export
fseList : {a : Type} -> {n : Nat} -> FinSubEncoding a n -> List a
fseList = snd

public export
FSEMember : {a : Type} -> {n : Nat} -> FinSubEncoding a n -> Type
FSEMember enc = ListMemberDec decEq (fseList enc)

public export
FSEMemberInj : {a : Type} -> {n : Nat} -> (fse : FinSubEncoding a n) ->
  (x, x' : FSEMember fse) -> fst0 x = fst0 x' -> x = x'
FSEMemberInj enc = ListMemberDecInj decEq (fseList enc)

public export
fseEq : {a : Type} -> {n : Nat} -> (enc : FinSubEncoding a n) ->
  FSEMember enc -> FSEMember enc -> Bool
fseEq enc x x' = fdeEq (fseEnc enc) (fst0 x) (fst0 x')

public export
fseLt : {a : Type} -> {n : Nat} ->
  (enc : FinSubEncoding a n) -> FSEMember enc -> FSEMember enc -> Bool
fseLt enc x x' = fdeLt (fseEnc enc) (fst0 x) (fst0 x')

public export
fseDecEq : {a : Type} -> {  n : Nat} -> (enc : FinSubEncoding a n) ->
  DecEqPred (FSEMember enc)
fseDecEq enc x x' = case fdeDecEq (fseEnc enc) (fst0 x) (fst0 x') of
  Yes eq => Yes $ FSEMemberInj enc x x' eq
  No neq => No $ \eq => case eq of Refl => neq Refl

-- A list with a length stored together with it at run time.
public export
record LList (a : Type) (len : Nat) where
  constructor MkLList
  llList : List a
  llValid : length llList = len

public export
Show a => (len : Nat) => Show (LList a len) where
  show (MkLList l _) = show l ++ "(len=" ++ show len ++ ")"

public export
record LLAlg (a, b : Type) where
  constructor MkLLAlg
  llZ : b
  llS : Nat -> a -> b -> b

public export
llCata : {len : Nat} -> LLAlg a b -> LList a len -> b
llCata {len} (MkLLAlg z s) (MkLList l valid) = llCataInternal z s len l valid
  where
  llCataInternal :
    b ->
    (Nat -> a -> b -> b) ->
    (len : Nat) ->
    (l : List a) ->
    length l = len ->
    b
  llCataInternal z s Z [] Refl = z
  llCataInternal z s (S n) (x :: xs) valid =
    s n x $ llCataInternal z s n xs $ injective valid

public export
InitLList : {a : Type} -> (l : List a) -> LList a (length l)
InitLList l = MkLList l Refl
