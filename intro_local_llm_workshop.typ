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

== Which "memory"?

Traditionally LLMs are deployed on GPUs, so the model needs to fit on the VRAM.

- *Exceptions:*
  - Newer Macs, some AMD chipsets, (and game consoles) use _unified memory_, which means that system RAM and VRAM are shared.
  - _GGUF_ model format makes offloading part of the model in system RAM easy, albeit with a small performance overhead.

Practically, "memory" refers to system RAM + VRAM.

== Deriving memory requirement from model size

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

One call to the LLM involves two main steps:

1. *Prefill/Prompt evaluation*: The model processes the whole prompt/context in one pass.
2. *Generation*: The model generates the output tokens one by one.

The speed for each step can be measured by *token per second*.

- Prefill is much faster because it's parallel
- Which one is more important depends on use case

== Factors affecting "speed"

- *Model size*: Larger model -> More computations and more data to move around
- *GPU processing power*: Usually measured in TFLOPS (floating point ops per second)
- *Quantization*: Lower quantization bits -> generally faster
- *Model features*: MoE, MTP...
- Others:
  - Underlying framework & drivers
  - Platform-specific optimizations

== Mixture of Experts (MoE)

#slide[
*Mixture of Experts* models contain many different sub-models (“experts”), and during inference only one "expert" is activated.#footnote[Simplified explanation]
- Memory requirement is still high, but inference speed is much faster.
- e.g. `Gemma-4-26B-A4B` has 26B parameters, but only 4B is activated at a time.
- Usually slightly _less capable_ compared to "dense" models at same size.
][
  #figure(
  image("imgs/diag_moe.png"),
  caption: [Illustration of MoE#footnote[Image credit: https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts]]
  )
]

== Multi-token Prediction (MTP)

#slide[
Some models support *Multi-token Prediction*, which uses a _"draft and verify"_ approach to generate multiple tokens in parallel, with _no accuracy loss_#footnote[Simplified explanation].
- If available, turning on can improve generation speed.
][
  #figure(
    image("imgs/diag_mtp.webp"),
    caption: [
      Visualizing MTP#footnote[
        Image credit: https://medium.com/data-science-collective/deepseek-explained-4-multi-token-prediction-33f11fe2b868
      ]
    ]
  )
]

= Model repositories and Inference frameworks

== Choosing an inference framework

- End goal is the same for all of them: An *OpenAI-compatible* API server.
- The main ones: vLLM, SGLang, Ollama, llama.cpp
  - For local deployment with quantized GGUFs, *llama.cpp* is recommended.
  - vLLM or SGLang may be a good choice for Nvidia hardware.
- Easy and powerful solutions:
  - *Ramalama* for people willing to work with containers. Uses vLLM or llama.cpp under the hood, while simplifying the setting up process.
  - *Unsloth studio* for people liking GUI. Full selection of models and quants available.

== Finding models to download

Major model repositories:

- *Huggingface*: https://huggingface.co/models
- *Ollama*: https://ollama.com/library?sort=newest

For finding quantized GGUFs:

- #link("https://unsloth.ai/docs/models/tutorials")[*Unsloth*] provides quants for all the latest open source models. It often comes with fixes for the model, and tutorials. _Recommended!_

= Demo

== Setting up a local LLM, live

1. Choosing a model based on the hardware
2. Downloading a quantized GGUF
3. Running it using a inference framework
