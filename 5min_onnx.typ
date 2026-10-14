#import "@preview/touying:0.8.0": *
#import themes.university: *
#import "@preview/numbly:0.1.0": numbly

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Run your neural nets anywhere™],
    subtitle: [Or, an ONNX and ort exploration],
    author: [Kei Tang],
    date: datetime.today(),
    institution: [Recurse Center],
    // contact: [contact\@mail.com],
    logo: emoji.octopus,
  ),
  config-common(new-section-slide-fn: none),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

= ONNX

==

#align(horizon)[
  - So....
  - You have trained a cool deep learning model using Pytorch (or your favorite framework). Now you want to run it on as many devices as possible: Laptop, phone, Raspberry Pi...

  - But...
  - Installing Pytorch on all these different devices is #raw("(´;︵;`)") #footnote[
    There is #link("https://github.com/pytorch/executorch")[`executorch`] but it involves writing platform-specific code
  ]
  - Is there a simple solution?
]

== Introducing, ONNX

#slide[
#align(horizon)[
  / ONNX (Open Neural Network Exchange): A common format to represent neural networks, designed to facilitate exchange of models across different frameworks.

  Workflow:
  - *Convert* model from the training framework to ONNX.
  - Run the model on devices with ONNX *runtime*.
  - Use different *execution providers* for different hardware for acceleration.
]
]

== How ONNX works

#slide[
- A neural network is a computational graph. Data flows through nodes, which represent *Operations*.
- The #link("https://onnx.ai/onnx/operators/index.html#l-onnx-operators")["list"] of supported operators is long: Convolution, Attention, Pooling...
- As long as you can execute the graph of operations, you can run model inference!
][
  #figure(
    image("imgs/onnx-lr.png", width: 75%),
    caption: [Linear regression as ONNX graph]
  )
]

== Exporting & Visualizing

#align(horizon)[
  - Exporting a Pytorch model:
  ```python
  torch_model = ImageClassifierModel()
  example_inputs = (torch.randn(1, 1, 32, 32),)
  onnx_program = torch.onnx.export(torch_model, example_inputs, dynamo=True)
  onnx_program.save("image_classifier_model.onnx")
  ```
  - Visualizing: https://netron.app/
]

== Run your neural nets anywhere (really)

#figure(
  image("imgs/onnx_eps.png", width: 90%),
  caption: [Execution Providers]
)


= ort

== Rust runtime for ONNX

#slide[
  #align(horizon)[
    / ort: Rust gateway to ONNX Runtime, supporting using both default ONNX runtime (in C++) and other Rust-native backends.
  ]
][
  #align(horizon)[
    #figure(
      image("imgs/ort-icon.png", width: 75%),
      caption: [Cute icon!]
    )
  ]
]

= Demo?

== I want to see a demo!

- My laptop is not suitable for this#footnote[No dGPU]!
#pause
- My desktop is also not suitable for this#footnote[Backends on Strix Halo is a bit unstable]!
#pause
- So I got XNNPACK EP working on my desktop#footnote[CPU Acceleration, requires compiling ONNX runtime from scratch].
- The LSTM model used in my voice project#footnote[\<100ms is acceptable, so it's kinda useless]:

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  figure(image("imgs/demo_xnnpack.png", width: 80%), caption: [XNNPACK]),
  figure(image("imgs/demo_cpu.png", width: 70%), caption: [Default CPU]),
)
