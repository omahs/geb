<a id="x-28GEB-DOCS-2FDOCS-3A-40INDEX-20MGL-PAX-3ASECTION-29"></a>
# The GEB Manual

## Table of Contents

- [1 Links][9bc5]
- [2 Getting Started][3d47]
- [3 Categorical Model][c2e9]
    - [3.1 Morphisms][ada9]
    - [3.2 Objects][dbe7]
- [4 The Geb Model][c1fb]
    - [4.1 Core Categories][5d9d]
        - [4.1.1 Subst Obj][ca6e]
        - [4.1.2 Subst Morph][ffb7]
    - [4.2 Accessors][b26a]
    - [4.3 Constructors][0c5c]
    - [4.4 api][6228]
    - [4.5 Examples][a17b]
- [5 Mixins][723a]
    - [5.1 Pointwise Mixins][d5d3]
    - [5.2 Pointwise API][2fcf]
    - [5.3 Mixins Examples][4938]

###### \[in package GEB-DOCS/DOCS\]
Welcome to the GEB project.

<a id="x-28GEB-DOCS-2FDOCS-3A-40LINKS-20MGL-PAX-3ASECTION-29"></a>
## 1 Links

Here is the [official repository](https://github.com/anoma/geb/tree/main/geb-cl)
and the [HTML documentation](https://anoma.github.io/geb/) for the latest version

<a id="x-28GEB-DOCS-2FDOCS-3A-40GETTING-STARTED-20MGL-PAX-3ASECTION-29"></a>
## 2 Getting Started

Welcome to the GEB Project

<a id="x-28GEB-DOCS-2FDOCS-3A-40MODEL-20MGL-PAX-3ASECTION-29"></a>
## 3 Categorical Model

The GEB theoretical model is one of category theorey

<a id="x-28GEB-DOCS-2FDOCS-3A-40MORPHISMS-20MGL-PAX-3ASECTION-29"></a>
### 3.1 Morphisms


<a id="x-28GEB-DOCS-2FDOCS-3A-40OBJECTS-20MGL-PAX-3ASECTION-29"></a>
### 3.2 Objects


<a id="x-28GEB-3A-40GEB-20MGL-PAX-3ASECTION-29"></a>
## 4 The Geb Model

###### \[in package GEB\]
Everything here relates directly to the underlying machinery of
`GEB`, or to abstractions that help extend it.

<a id="x-28GEB-3A-40GEB-CATEGORIES-20MGL-PAX-3ASECTION-29"></a>
### 4.1 Core Categories

The underlying category of `GEB`. With [Subst Obj][ca6e] covering the
shapes and forms ([Objects][dbe7]) of data while [Subst Morph][ffb7]
deals with concrete [Morphisms][ada9] within the category

<a id="x-28GEB-3A-40GEB-SUBSTMU-20MGL-PAX-3ASECTION-29"></a>
#### 4.1.1 Subst Obj

This Category covers the objects of the `GEB` category. Every value
that is a [`SUBSTOBJ`][718e] is automatically lifted into a [`SUBSTMORPH`][e5d9] when a
`SUBSTMORPH` is expected.

The Type that encomposes the [`SUBSTOBJ`][718e] category

<a id="x-28GEB-3ASUBSTOBJ-20TYPE-29"></a>
- [type] **SUBSTOBJ**

The various constructors that form the [`SUBSTOBJ`][718e] type

<a id="x-28GEB-3APROD-20TYPE-29"></a>
- [type] **PROD**

    the product

<a id="x-28GEB-3ACOPROD-20TYPE-29"></a>
- [type] **COPROD**

    the coproduct

<a id="x-28GEB-3ASO0-20TYPE-29"></a>
- [type] **SO0**

    The Initial/Void Object

<a id="x-28GEB-3ASO1-20TYPE-29"></a>
- [type] **SO1**

    The Terminal/Unit Object

<a id="x-28GEB-3AALIAS-20TYPE-29"></a>
- [type] **ALIAS**

    an alias for a geb object

The [Accessors][b26a] specific to [Subst Obj][ca6e]

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3APROD-29-29-29"></a>
- [method] **MCAR** *(PROD PROD)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3APROD-29-29-29"></a>
- [method] **MCADR** *(PROD PROD)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3ACOPROD-29-29-29"></a>
- [method] **MCAR** *(COPROD COPROD)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3ACOPROD-29-29-29"></a>
- [method] **MCADR** *(COPROD COPROD)*

<a id="x-28GEB-3A-40GEB-SUBSTMORPH-20MGL-PAX-3ASECTION-29"></a>
#### 4.1.2 Subst Morph

The moprhisms of the `GEB` category.

The Type that encomposes the SUBSTMOPRH category

<a id="x-28GEB-3ASUBSTMORPH-20TYPE-29"></a>
- [type] **SUBSTMORPH**

The various constructors that form the [`SUBSTMORPH`][e5d9] type

<a id="x-28GEB-3ACOMP-20TYPE-29"></a>
- [type] **COMP**

    Composition of morphism

<a id="x-28GEB-3ACASE-20TYPE-29"></a>
- [type] **CASE**

    Coproduct elimination (case statement)

<a id="x-28GEB-3AINIT-20TYPE-29"></a>
- [type] **INIT**

    The initial Morphism

<a id="x-28GEB-3ATERMINAL-20TYPE-29"></a>
- [type] **TERMINAL**

    The terminal Morhpism

<a id="x-28GEB-3APAIR-20TYPE-29"></a>
- [type] **PAIR**

    Product introduction (morphism pairing)

<a id="x-28GEB-3ADISTRIBUTE-20TYPE-29"></a>
- [type] **DISTRIBUTE**

    The distributive law

<a id="x-28GEB-3AINJECT-LEFT-20TYPE-29"></a>
- [type] **INJECT-LEFT**

    Left injection (coproduct introduction)

<a id="x-28GEB-3AINJECT-RIGHT-20TYPE-29"></a>
- [type] **INJECT-RIGHT**

    Right injection (coproduct introduction)

<a id="x-28GEB-3APROJECT-LEFT-20TYPE-29"></a>
- [type] **PROJECT-LEFT**

    Left projection (product elimination)

<a id="x-28GEB-3APROJECT-RIGHT-20TYPE-29"></a>
- [type] **PROJECT-RIGHT**

<a id="x-28GEB-3AFUNCTOR-20TYPE-29"></a>
- [type] **FUNCTOR**

<a id="x-28GEB-3AALIAS-20TYPE-29"></a>
- [type] **ALIAS**

    an alias for a geb object

The [Accessors][b26a] specific to [Subst Morph][ffb7]

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3ACOMP-29-29-29"></a>
- [method] **MCAR** *(COMP COMP)*

    The first composed morphism

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3ACOMP-29-29-29"></a>
- [method] **MCADR** *(COMP COMP)*

    the second morphism

<a id="x-28GEB-3AOBJ-20-28METHOD-20NIL-20-28GEB-3AINIT-29-29-29"></a>
- [method] **OBJ** *(INIT INIT)*

<a id="x-28GEB-3AOBJ-20-28METHOD-20NIL-20-28GEB-3AINIT-29-29-29"></a>
- [method] **OBJ** *(INIT INIT)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3ACASE-29-29-29"></a>
- [method] **MCAR** *(CASE CASE)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3ACASE-29-29-29"></a>
- [method] **MCADR** *(CASE CASE)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3APAIR-29-29-29"></a>
- [method] **MCAR** *(PAIR PAIR)*

    Head of the pair cell

<a id="x-28GEB-3AMCDR-20-28METHOD-20NIL-20-28GEB-3APAIR-29-29-29"></a>
- [method] **MCDR** *(PAIR PAIR)*

    Tail of the pair cell

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3ADISTRIBUTE-29-29-29"></a>
- [method] **MCAR** *(DISTRIBUTE DISTRIBUTE)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3ADISTRIBUTE-29-29-29"></a>
- [method] **MCADR** *(DISTRIBUTE DISTRIBUTE)*

<a id="x-28GEB-3AMCADDR-20-28METHOD-20NIL-20-28GEB-3ADISTRIBUTE-29-29-29"></a>
- [method] **MCADDR** *(DISTRIBUTE DISTRIBUTE)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3AINJECT-LEFT-29-29-29"></a>
- [method] **MCAR** *(INJECT-LEFT INJECT-LEFT)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3AINJECT-LEFT-29-29-29"></a>
- [method] **MCADR** *(INJECT-LEFT INJECT-LEFT)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3AINJECT-RIGHT-29-29-29"></a>
- [method] **MCAR** *(INJECT-RIGHT INJECT-RIGHT)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3AINJECT-RIGHT-29-29-29"></a>
- [method] **MCADR** *(INJECT-RIGHT INJECT-RIGHT)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3APROJECT-LEFT-29-29-29"></a>
- [method] **MCAR** *(PROJECT-LEFT PROJECT-LEFT)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3APROJECT-LEFT-29-29-29"></a>
- [method] **MCADR** *(PROJECT-LEFT PROJECT-LEFT)*

<a id="x-28GEB-3AMCAR-20-28METHOD-20NIL-20-28GEB-3APROJECT-RIGHT-29-29-29"></a>
- [method] **MCAR** *(PROJECT-RIGHT PROJECT-RIGHT)*

<a id="x-28GEB-3AMCADR-20-28METHOD-20NIL-20-28GEB-3APROJECT-RIGHT-29-29-29"></a>
- [method] **MCADR** *(PROJECT-RIGHT PROJECT-RIGHT)*

    Right projection (product elimination)

<a id="x-28GEB-3A-40GEB-ACCESSORS-20MGL-PAX-3ASECTION-29"></a>
### 4.2 Accessors

These functions relate to grabbing slots out of the various
[Subst Morph][ffb7] and [Subst Obj][ca6e] types. See those sections for
specific instance documentation

<a id="x-28GEB-3AMCAR-20GENERIC-FUNCTION-29"></a>
- [generic-function] **MCAR** *OBJECT*

<a id="x-28GEB-3AMCADR-20GENERIC-FUNCTION-29"></a>
- [generic-function] **MCADR** *OBJECT*

<a id="x-28GEB-3AMCDR-20GENERIC-FUNCTION-29"></a>
- [generic-function] **MCDR** *OBJECT*

<a id="x-28GEB-3AMCADDR-20GENERIC-FUNCTION-29"></a>
- [generic-function] **MCADDR** *OBJECT*

<a id="x-28GEB-3AOBJ-20GENERIC-FUNCTION-29"></a>
- [generic-function] **OBJ** *OBJECT*

<a id="x-28GEB-3ANAME-20GENERIC-FUNCTION-29"></a>
- [generic-function] **NAME** *OBJECT*

<a id="x-28GEB-3AFUNC-20GENERIC-FUNCTION-29"></a>
- [generic-function] **FUNC** *OBJECT*

<a id="x-28GEB-3A-40GEB-CONSTRUCTORS-20MGL-PAX-3ASECTION-29"></a>
### 4.3 Constructors

The API for creating `GEB` terms. All the functions and variables
here relate to instantiating a term

<a id="x-28GEB-3A-2ASO0-2A-20VARIABLE-29"></a>
- [variable] **\*SO0\*** *s-0*

    The Initial Object

<a id="x-28GEB-3A-2ASO1-2A-20VARIABLE-29"></a>
- [variable] **\*SO1\*** *s-1*

    The Terminal Object

More Ergonomic API variants for [`*SO0*`][9f7a] and [`*SO1*`][6380]

<a id="x-28GEB-3ASO0-20MGL-PAX-3ASYMBOL-MACRO-29"></a>
- [symbol-macro] **SO0**

<a id="x-28GEB-3ASO1-20MGL-PAX-3ASYMBOL-MACRO-29"></a>
- [symbol-macro] **SO1**

<a id="x-28GEB-3AMAKE-ALIAS-20FUNCTION-29"></a>
- [function] **MAKE-ALIAS** *&KEY NAME OBJ*

<a id="x-28GEB-3A-3C-LEFT-20FUNCTION-29"></a>
- [function] **\<-LEFT** *MCAR MCADR*

    projects left constructor

<a id="x-28GEB-3A-3C-RIGHT-20FUNCTION-29"></a>
- [function] **\<-RIGHT** *MCAR MCADR*

    projects right constructor

<a id="x-28GEB-3ALEFT--3E-20FUNCTION-29"></a>
- [function] **LEFT-\>** *MCAR MCADR*

    injects left constructor

<a id="x-28GEB-3ARIGHT--3E-20FUNCTION-29"></a>
- [function] **RIGHT-\>** *MCAR MCADR*

    injects right constructor

<a id="x-28GEB-3AMCASE-20FUNCTION-29"></a>
- [function] **MCASE** *MCAR MCADR*

<a id="x-28GEB-3AMAKE-FUNCTOR-20FUNCTION-29"></a>
- [function] **MAKE-FUNCTOR** *&KEY OBJ FUNC*

<a id="x-28GEB-3A-40GEB-API-20MGL-PAX-3ASECTION-29"></a>
### 4.4 api

Various functions that make working with `GEB` easier

<a id="x-28GEB-3APAIR-TO-LIST-20FUNCTION-29"></a>
- [function] **PAIR-TO-LIST** *PAIR &OPTIONAL ACC*

    converts excess pairs to a list format

<a id="x-28GEB-3ASAME-TYPE-TO-LIST-20FUNCTION-29"></a>
- [function] **SAME-TYPE-TO-LIST** *PAIR TYPE &OPTIONAL ACC*

    converts the given type to a list format

<a id="x-28GEB-3AMLIST-20FUNCTION-29"></a>
- [function] **MLIST** *V1 &REST VALUES*

<a id="x-28GEB-3ACOMMUTES-20FUNCTION-29"></a>
- [function] **COMMUTES** *X Y*

<a id="x-28GEB-3A-21--3E-20FUNCTION-29"></a>
- [function] **!-\>** *A B*

<a id="x-28GEB-3ASO-EVAL-20FUNCTION-29"></a>
- [function] **SO-EVAL** *X Y*

<a id="x-28GEB-3A-40GEB-EXAMPLES-20MGL-PAX-3ASECTION-29"></a>
### 4.5 Examples

PLACEHOLDER: TO SHOW OTHERS HOW `EXAMPLE`s WORK

Let's see the transcript of a real session of someone working
with `GEB`:

```common-lisp
(values (princ :hello) (list 1 2))
.. HELLO
=> :HELLO
=> (1 2)

(+ 1 2 3 4)
=> 10
```


<a id="x-28GEB-2EMIXINS-3A-40MIXINS-20MGL-PAX-3ASECTION-29"></a>
## 5 Mixins

###### \[in package GEB.MIXINS\]
Various [mixins](https://en.wikipedia.org/wiki/Mixin) of the
project. Overall all these offer various services to the rest of the
project

<a id="x-28GEB-2EMIXINS-3A-40POINTWISE-20MGL-PAX-3ASECTION-29"></a>
### 5.1 Pointwise Mixins

Here we provide various mixins that deal with classes in a pointwise
manner. Normally, objects can not be compared in a pointwise manner,
instead instances are compared. This makes functional idioms like
updating a slot in a pure manner (allocating a new object), or even
checking if two objects are [`EQUAL`][96d0]-able adhoc. The pointwise API,
however, derives the behavior and naturally allows such idioms

<a id="x-28GEB-2EMIXINS-3APOINTWISE-MIXIN-20CLASS-29"></a>
- [class] **POINTWISE-MIXIN**

    Provides the service of giving point wise
    operations to classes

Further we may wish to hide any values inherited from our superclass
due to this we can instead compare only the slots defined directly
in our class

<a id="x-28GEB-2EMIXINS-3ADIRECT-POINTWISE-MIXIN-20CLASS-29"></a>
- [class] **DIRECT-POINTWISE-MIXIN** *[POINTWISE-MIXIN][445d]*

    Works like [`POINTWISE-MIXIN`][445d], however functions on
    [`POINTWISE-MIXIN`][445d] will only operate on direct-slots
    instead of all slots the class may contain.
    
    Further all `DIRECT-POINTWISE-MIXIN`'s are [`POINTWISE-MIXIN`][445d]'s

<a id="x-28GEB-2EMIXINS-3A-40POINTWISE-API-20MGL-PAX-3ASECTION-29"></a>
### 5.2 Pointwise API

These are the general API functions on any class that have the
[`POINTWISE-MIXIN`][445d] service.

Functions like [`TO-POINTWISE-LIST`][58a9] allow generic list traversal APIs to
be built off the key-value pair of the raw object form, while
[`OBJ-EQUALP`][c111] allows the checking of functional equality between
objects. Overall the API is focused on allowing more generic
operations on classes that make them as useful for generic data
traversal as `LIST`([`0`][592c] [`1`][98f9])'s are

<a id="x-28GEB-2EMIXINS-3ATO-POINTWISE-LIST-20GENERIC-FUNCTION-29"></a>
- [generic-function] **TO-POINTWISE-LIST** *OBJ*

    Turns a given object into a pointwise `LIST`([`0`][592c] [`1`][98f9]). listing
    the [`KEYWORD`][4850] slot-name next to their value.

<a id="x-28GEB-2EMIXINS-3AOBJ-EQUALP-20GENERIC-FUNCTION-29"></a>
- [generic-function] **OBJ-EQUALP** *OBJECT1 OBJECT2*

    Compares objects with pointwise equality. This is a
    much weaker form of equality comparison than
    [`STANDARD-OBJECT`][a802] [`EQUALP`][c721], which does the much
    stronger pointer quality

<a id="x-28GEB-2EMIXINS-3APOINTWISE-SLOTS-20GENERIC-FUNCTION-29"></a>
- [generic-function] **POINTWISE-SLOTS** *OBJ*

    Works like `C2MOP:COMPUTE-SLOTS` however on the object
    rather than the class

<a id="x-28GEB-2EMIXINS-3A-40MIXIN-EXAMPLES-20MGL-PAX-3ASECTION-29"></a>
### 5.3 Mixins Examples

Let's see some example uses of [`POINTWISE-MIXIN`][445d]:

```common-lisp
(obj-equalp (geb:terminal geb:so1)
            (geb:terminal geb:so1))
=> t

(to-pointwise-list (geb:coprod geb:so1 geb:so1))
=> ((:MCAR . s-1) (:MCADR . s-1))
```


  [0c5c]: #x-28GEB-3A-40GEB-CONSTRUCTORS-20MGL-PAX-3ASECTION-29 "Constructors"
  [2fcf]: #x-28GEB-2EMIXINS-3A-40POINTWISE-API-20MGL-PAX-3ASECTION-29 "Pointwise API"
  [3d47]: #x-28GEB-DOCS-2FDOCS-3A-40GETTING-STARTED-20MGL-PAX-3ASECTION-29 "Getting Started"
  [445d]: #x-28GEB-2EMIXINS-3APOINTWISE-MIXIN-20CLASS-29 "GEB.MIXINS:POINTWISE-MIXIN CLASS"
  [4850]: http://www.lispworks.com/documentation/HyperSpec/Body/t_kwd.htm "KEYWORD TYPE"
  [4938]: #x-28GEB-2EMIXINS-3A-40MIXIN-EXAMPLES-20MGL-PAX-3ASECTION-29 "Mixins Examples"
  [58a9]: #x-28GEB-2EMIXINS-3ATO-POINTWISE-LIST-20GENERIC-FUNCTION-29 "GEB.MIXINS:TO-POINTWISE-LIST GENERIC-FUNCTION"
  [592c]: http://www.lispworks.com/documentation/HyperSpec/Body/f_list_.htm "LIST FUNCTION"
  [5d9d]: #x-28GEB-3A-40GEB-CATEGORIES-20MGL-PAX-3ASECTION-29 "Core Categories"
  [6228]: #x-28GEB-3A-40GEB-API-20MGL-PAX-3ASECTION-29 "api"
  [6380]: #x-28GEB-3A-2ASO1-2A-20VARIABLE-29 "GEB:*SO1* VARIABLE"
  [718e]: #x-28GEB-3ASUBSTOBJ-20TYPE-29 "GEB:SUBSTOBJ TYPE"
  [723a]: #x-28GEB-2EMIXINS-3A-40MIXINS-20MGL-PAX-3ASECTION-29 "Mixins"
  [96d0]: http://www.lispworks.com/documentation/HyperSpec/Body/f_equal.htm "EQUAL FUNCTION"
  [98f9]: http://www.lispworks.com/documentation/HyperSpec/Body/t_list.htm "LIST TYPE"
  [9bc5]: #x-28GEB-DOCS-2FDOCS-3A-40LINKS-20MGL-PAX-3ASECTION-29 "Links"
  [9f7a]: #x-28GEB-3A-2ASO0-2A-20VARIABLE-29 "GEB:*SO0* VARIABLE"
  [a17b]: #x-28GEB-3A-40GEB-EXAMPLES-20MGL-PAX-3ASECTION-29 "Examples"
  [a802]: http://www.lispworks.com/documentation/HyperSpec/Body/t_std_ob.htm "STANDARD-OBJECT TYPE"
  [ada9]: #x-28GEB-DOCS-2FDOCS-3A-40MORPHISMS-20MGL-PAX-3ASECTION-29 "Morphisms"
  [b26a]: #x-28GEB-3A-40GEB-ACCESSORS-20MGL-PAX-3ASECTION-29 "Accessors"
  [c111]: #x-28GEB-2EMIXINS-3AOBJ-EQUALP-20GENERIC-FUNCTION-29 "GEB.MIXINS:OBJ-EQUALP GENERIC-FUNCTION"
  [c1fb]: #x-28GEB-3A-40GEB-20MGL-PAX-3ASECTION-29 "The Geb Model"
  [c2e9]: #x-28GEB-DOCS-2FDOCS-3A-40MODEL-20MGL-PAX-3ASECTION-29 "Categorical Model"
  [c721]: http://www.lispworks.com/documentation/HyperSpec/Body/f_equalp.htm "EQUALP FUNCTION"
  [ca6e]: #x-28GEB-3A-40GEB-SUBSTMU-20MGL-PAX-3ASECTION-29 "Subst Obj"
  [d5d3]: #x-28GEB-2EMIXINS-3A-40POINTWISE-20MGL-PAX-3ASECTION-29 "Pointwise Mixins"
  [dbe7]: #x-28GEB-DOCS-2FDOCS-3A-40OBJECTS-20MGL-PAX-3ASECTION-29 "Objects"
  [e5d9]: #x-28GEB-3ASUBSTMORPH-20TYPE-29 "GEB:SUBSTMORPH TYPE"
  [ffb7]: #x-28GEB-3A-40GEB-SUBSTMORPH-20MGL-PAX-3ASECTION-29 "Subst Morph"

* * *
###### \[generated by [MGL-PAX](https://github.com/melisgl/mgl-pax)\]