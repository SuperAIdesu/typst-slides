#import "@preview/touying:0.8.0": *
#import themes.stargazer: *
#import "@preview/numbly:0.1.0": numbly

#show: stargazer-theme.with(
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

#outline-slide()

= Introduction

== Why local LLMs?

- Privacy: Cloud providers may retain your data or use it for training
- Cost: Powerful cloud models are expensive
- Research and learning: Know more about how LLMs work
- and more?

== What I will not cover

- Harness: Models are generally decoupled from harnesses

#pause

- Training: Maybe another workshop in the future?

#pause

- Platform specific things (e.g. Metal for Macs, Nvidia stuff): I don't own those hardware, but we can look into it together!

= Model sizes and memory: What model can I run?

== Getting a feel on different model sizes

== vRAM, RAM and unified memory

== Quantization

== Using disk space? (Advanced)

= GPUs and optimizations: How fast will the model run?

== How "speed" is measured

== Factors affecting "speed"

== Optimizations: MTP

== Optimizations: NVFP4 (Advanced)

= Practical stuff

== Where to find & download models?

== All the different frameworks!

= Demo

== Setting up a local LLM, live

1. Choosing a (quantized) model
2. Running it in llama.cpp
3. Running it in Ramalama
