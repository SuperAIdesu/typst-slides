#import "@preview/touying:0.8.0": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Intro to Local LLMs],
    // subtitle: [Customize Your Slide Subtitle Here],
    author: [Kei Tang],
    date: datetime.today(),
    institution: [Recurse Center],
    // contact: [contact\@mail.com],
    logo: emoji.octopus,
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

= Outline <touying:hidden>

#outline(title: none, indent: 1em, depth: 1)

= Introduction

== Why local LLMs?

- *Privacy*: Cloud providers may retain your data or use it for training
- *Cost*: Powerful cloud models are expensive
- *Research and learning*: Know more about how LLMs work
- *Ethics*: Avoid the big model providers controlling the technology
- and more?

== Local LLMs are quite powerful now

#figure(
  image("imgs/aa_index.png", width: 100%),
  caption: [
    The AA Intelligence Index. (_Take all benchmark rankings with a grain of salt!_)
  ]
)

== What I will not cover

- *Harness*: Models are generally decoupled from harnesses

- *Training*: Maybe another workshop in the future?

- *Platform specific settings (e.g. Metal for Macs, Nvidia stuff)*: I don't own those hardware, but we can look into it together!

= Model sizes and memory: What model can I run?

== Getting a feel on different model sizes

Model size for language models are usually characterized by *number of parameters* (in billions):

- The scaling era: GPT-2: 1.5B, GPT-3: 175B, GPT-4: 1.8T (unconfirmed)
- Best open models: \~1T
- With consumer hardware, 100B is usually the limit (...Why?)

== Model size and memory requirement

=== Which "memory"?

(Usually) LLMs are deployed on GPUs, so the model needs to fit on the VRAM.

- *Exceptions:* Newer Macs, some AMD chipsets, (and game consoles) use _unified memory_, which means that system RAM can work as VRAM.

#pause

=== Deriving memory requirement from model size

- *Model parameters:* $"memory" = "number of parameters" * "bits per parameter"$
  - By default, LLMs use `FP16` (16bit). A 100B model will consume $100"B" * 16"bit" = 200"GB"$.
- *Dynamic memory usage:* Additional memory is required to store intermediate computation values (mostly KV cache).
  - This part _grows with context length_. When a large context length is required, this extra memory can be as large as $0.5 * "model size"$.

== Quantization

#slide[
  *Quantization* takes an existing model, reduces memory usage by changing the numeric data structure for parameters, usually with little drop in accuracy.

  - Classic quantization methods use `INT8` or `INT4`.
  - Recent methods dynamically select some parameters to quantize in order to minimize accuracy loss. _Quants_ range from 1 to 8 bits.
  - eg. $100"B" * 4"bit" = 50"GB"$
][
  #figure(
  image("imgs/diag_quantization.png"),
  caption: [From `FP32` to `INT8`#footnote[Image credit: https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization]]
  )
]

#slide[
  #figure(
    image("imgs/qwen38_unsloth_quants_acc.webp", width: 75%),
    caption: [The different Qwen3.8-27B quants (X: model size, Y: Top-1 accuracy)#footnote[https://unsloth.ai/docs/basics/dynamic-3.0-ggufs]]
  )
]

#slide[
  As a general rule of thumb:
  - Memory (in GB) \~ the size (in B) of model you can run comfortably when quantized
]

= GPUs and optimizations: How fast will the model run?

== How "speed" is measured

== Factors affecting "speed"

== Optimizations: MTP

= Model repositories and Inference frameworks

== Where to find & download models?

== All the different frameworks!

= Demo

== Setting up a local LLM, live

1. Choosing a (quantized) model
2. Running it in llama.cpp
3. Running it in Ramalama
