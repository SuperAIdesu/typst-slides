#import "@preview/touying:0.8.0": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/fletcher:0.5.8" as fletcher: node, edge
#import "@preview/codly:2.0.0" as codly
#import "@preview/codly-languages:0.1.10": codly-languages

#show: codly.lang-set_(languages: codly-languages)
#show raw.where(block: true): it => if it.lang == "plain" { it } else { codly.new(it) }

#let fletcher-diagram = touying-reduce.with(fletcher)

#set text(
  font: "Fira Sans",
  weight: "light",
  size: 20pt,
)
#show raw: set text(font: "FiraCode Nerd Font Mono")
#show raw.where(block: true): set text(size: 13pt)

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  // catppuccin latte
  config-colors(
    primary: rgb("#7287fd"),
    primary-light: rgb("#7287fd"),
    secondary: rgb("#ea76cb"),
    neutral-lightest: rgb("#eff1f5"),
    neutral-dark: rgb("#5c5f77"),
    neutral-darkest: rgb("#4c4f69"),
  ),
  // align: horizon,
  // config-common(handout: true),
  config-info(
    title: [How Sumigoe was built],
    subtitle: [Learnings from building a Rust app],
    author: [Kei Tang],
    date: datetime.today(),
    institution: [Recurse Center],
    // contact: [contact\@mail.com],
    logo: emoji.octopus,
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

= Intro

== What is Sumigoe?

It's a companion app for *voice therapy/training*. It's designed mainly for trans, non-binary and gender non-conforming people, who would like to modify the perceived qualities of their voices.

The main feature is *realtime pitch and resonance (formants) tracking and visualization*#footnote[I will not explain too much on what formants are in this presentation, for the sake of time, but feel free to read this: https://www.voicescienceworks.org/harmonics-vs-formants.html], providing important feedback for users' learning and practice.

== Demo/screenshot

// https://github.com/touying-typ/touying-exporter
// Use this to put GIF
[Insert Graphics here]

== How it works (as a data scientist)

- Audio data comes in as 1D vectors
- I have prepared cool ML models:
  - *DeepFormants*#footnote[Refactored and trained by me: https://tangled.org/superaidesu.tngl.sh/deepformants_features] (an LSTM model) for formant tracking
  - *CREPE*#footnote[Pre-trained by researchers: https://github.com/marl/crepe] (a CNN model) for pitch estimation
- They output a time series of predictions, and I can just show them

#v(1em)
Fairly straightforward?

#slide[
  // 17pt keeps the whole graph inside the 761.89pt x 383.56pt slide area
  #text(size: 17pt, fletcher-diagram(
    node-stroke: .5pt,
    node-fill: rgb("#f0f4f8"),
    node-inset: 5pt,
    spacing: (62pt, 62pt),
    {
      // Sources
      node((0, 0), align(center)[
        *Microphone* \
        #text(size: 0.8em)[1D audio samples]
      ], shape: fletcher.shapes.pill, inset: 16pt, fill: rgb("#e3ecf7"))

      // Feature extraction + models
      node((1, -1), align(center)[
        *Feature extraction* \
        #text(size: 0.8em)[350-dim feature\ vector per frame]
      ], fill: rgb("#fdf3e3"))
      node((2, -1), align(center)[
        *Deepformants* \
        #text(size: 0.8em)[LSTM model]
      ], fill: rgb("#e8f4e8"), shape: fletcher.shapes.pill, inset: 16pt)

      node((2, 1), align(center)[
        *CREPE* \
        #text(size: 0.8em)[CNN model]
      ], fill: rgb("#e8f4e8"), shape: fletcher.shapes.pill, inset: 16pt)

      // Outputs
      node((3, 0), align(center)[
        *Real-time plots*
      ], fill: rgb("#f3e8f4"))

      // Edges (1-D audio throughout DSP stages)
      edge((0, 0), (1, -1), "-|>", label: text(0.8em)[Audio frames], label-side: left, label-pos: 0.3)
      edge((1, -1), (2, -1), "-|>", label: text(0.8em)[Feature\ vectors])
      edge((0, 0), (2, 1), "-|>", label: text(0.8em)[Audio frames], label-side: right, label-pos: 0.3, label-sep: 1em)
      edge((2, -1), (3, 0), "-|>", label: text(0.8em)[Formants $\{F_1..F_4\}$], label-pos: 0.4)
      edge((2, 1), (3, 0), "-|>", label: text(0.8em)[$F_0$ + voicing probability], label-pos: 0.4, label-side: right)
    }
  ))
]

==

#focus-slide[
  But as a software engineer, it's not that easy anymore!
]

== Software design considerations and why I choose Rust

- I would like the app to be *corss-platform* (desktop and mobile).
- I would like to deploy *ML models on-device* and optimize them.
- I would like the app to be *local* and private, without the need to deploy a server.
- #strike[I would like to minimize the need to learn web development, such as JS/TS.]

#pause
Why Rust fits my needs?

- Code naturally compiles to multiple platforms
- I can use ONNX Runtime to optimize ML inference on different hardware
- GUI frameworks in Rust is gaining traction recently
- #strike[Rust is fun! Rust is exciting! #emoji.crab]

= GUI

== Are we GUI yet?

#slide(composer: (1fr, auto))[
  - Rust GUI framework landscape is still quite fragmented and not very mature#footnote[`Tauri` is probably the most mature one, but it's more like a wrapper similar to Electron.].
  - Two main types of GUI frameworks:
    - *Reactive*: Tracks data dependencies of the UI, and only changes the components affected when the data changes. (`Dioxus`, `Leptos`)
    - *Immediate*: Each re-render redraws the entire frame. (`egui`, `GPUI`)
  - I chose `Dioxus` because it's one of the most mature ones, and reactive mode can simplify the process of building a UI.
][
  #image("imgs/sumigoe/are_we_gui.png", width: 300pt)
]

== Writing HTML and CSS, in Rust

#slide[
  - In `Dioxus`, UI is declared using `rsx!` macro.
  - HTML elements and CSS classes are written in the macro. It's said to be "a blend between HTML and SwiftUI".
  - There are a lot of syntax sugar in `rsx!`, for things like conditional rendering and string formatting.
  - It's rendered using _system Webview_#footnote[There is also a experimental native renderer.] on desktop and mobile.
][
  ```rs
  #[component]
  pub fn NavBar() -> Element {
      rsx! {
          div { class: "...",
              div { class: "...",
                  button { class: "..."}
                  }
              }
          }
      }
  }
  ```
]

== Signals: the building block of reactive state

- Web developers may be familiar with the concept of a reactive *signal*: sources of "state" from which the UI elements are derived. `Dioxus` uses the same concept.
- For example, a toggle button looks like this:

#codly.new(
  ```rs
  pub fn Footer() -> Element {
      let debug_toggle = use_signal(|| false);
      rsx! {
          label { class: "...",
              input { // ...
                  onchange: move |evt| {
                      let value = evt.value().parse::<bool>().unwrap_or(false);
                      debug_toggle.set(value);
                  },
              } // ...
              "Debug"
          }
      }
  }
  ```,
  highlights: (
    (line: 2, start: 24, end: 43),
    (line: 8, start: 21, end: 43)
  ),
  range: (2, 10),
)

== Signal, for Rustaceans

- Signal is built on top of `GenerationalBox`, which can be understood as a fancy _smart pointer_:
  - It wraps over a reference to a `RefCell`, therefore has *Interior mutability*.
  - Borrow safety checks happen at runtime.
  - It implements *`Copy` trait*, which allows easy moving between scopes
- Using `.read()` and `.write()` methods gives standard immutable/mutable references with `Deref`.
- It has thread-safe variants (`SyncStorage`), which is important later.

= Threads and message passing

== Real-time audio processing requires multiple threads

Many different workloads need to happen at the same time:

- `cpal` audio *input/playback* interfaces with low-level device sample streams, which needs to be fast and unblocking.
- Audio from microphone needs to be *resampled* to 16kHz before sending to ML models using `rubato`.
- *Inference* for the 2 ML models, which need to keep different context data.
- *Rendering* for the UI and plots, which should not be blocked by ML inference delays.

How to structure the threads? And how to share data between them?

== Message passing using channels

#quote(block: true, attribution: [Go documentation, and multiple RC presentations])[
  Do not communicate by sharing memory; instead, share memory by communicating.
]

In Rust, message passing is done by using `mpsc` (multiple provider, single consumer) channels. (`Sender` can be cloned)

```rs
fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
}
```

== A worker thread that can send and receive messages

#slide(composer: (2fr, 3fr))[
- `Dioxus` integrates `tokio` async runtime, so here `tokio`'s mpsc channels are used.
- UI thread can receive messages in an async task.
- Worker thread: polls for messages, runs workload when there is enough data, and sends out the output.
][
  ```rs
  pub fn init(
      mut on_receive: impl FnMut(MessageFromWorker) + Send + 'static,
  ) -> mpsc::UnboundedSender<MessageToWorker> {
      let (to_tx, to_rx) = mpsc::unbounded_channel();
      let (from_tx, mut from_rx) = mpsc::unbounded_channel();
      spawn_worker(to_rx, from_tx);
      tokio::spawn(async move {
          while let Some(msg) = from_rx.recv().await {
              on_receive(msg);
          }
      });
      to_tx
  }
  ```
]

== The complete architecture

#slide[
  #align(center, box({
    // legend overlaid on the empty top-left corner of the graph
    place(top + left, dx: 6pt, dy: 2pt, text(size: 12pt, grid(
      columns: (auto, auto),
      column-gutter: 6pt,
      row-gutter: 4pt,
      align: horizon,
      fletcher.diagram(
        edge-stroke: .6pt,
        spacing: 44pt,
        edge((0, 0), (1, 0), "-|>"),
      ),
      [Unbounded channel: the sender never blocks],
      fletcher.diagram(
        edge-stroke: .6pt,
        spacing: 44pt,
        edge((0, 0), (1, 0), "-|>", stroke: (thickness: .6pt, dash: "dotted")),
      ),
      [Bounded channel: message dropped when full],
    )))

    // note in the empty bottom-left corner (negative dy lifts it off the edge)
    place(bottom + left, dx: 6pt, dy: -30pt, text(
      size: 12pt,
      fill: rgb("#5c5f77"),
      [\*Some channels for event and error handling are not shown],
    ))

    text(size: 16pt, fletcher-diagram(
      node-stroke: .5pt,
      edge-stroke: .6pt,
      node-fill: rgb("#f0f4f8"),
      node-inset: 5pt,
      spacing: (62pt, 60pt),
    {
      // cpal audio callback thread
      node((0, 0), align(center)[
        *Microphone* \
        #text(size: 0.8em)[from device\ callback]
      ], shape: fletcher.shapes.pill, inset: 14pt, fill: rgb("#e3ecf7"))

      // hub thread: resample + fan-out
      node((1, 0), align(center)[
        *Hub thread* \
        #text(size: 0.8em)[resample to 16kHz,\ emits fixed-size hops]
      ], fill: rgb("#fdf3e3"))

      // model worker threads
      node((2, -1), align(center)[
        *Formant worker* \
        #text(size: 0.8em)[feature extraction\ + LSTM model]
      ], fill: rgb("#e8f4e8"), shape: fletcher.shapes.pill, inset: 14pt)

      node((2, 1), align(center)[
        *Pitch worker* \
        #text(size: 0.8em)[CNN model]
      ], fill: rgb("#e8f4e8"), shape: fletcher.shapes.pill, inset: 14pt)

      // UI thread + playback thread
      node((3, 0), align(center)[
        *UI thread\ (Dioxus)* \
        #text(size: 0.8em)[capture data\ into signals]
      ], fill: rgb("#f3e8f4"))

      node((3, 1), align(center)[
        *Playback thread* \
        #text(size: 0.8em)[send to device]
      ], shape: fletcher.shapes.pill, inset: 14pt, fill: rgb("#e3ecf7"))

      // channels: solid = unbounded, dotted = bounded
      edge((0, 0), (1, 0), "-|>", label: text(0.7em)[`Vec<f32>`])
      edge((1, 0), (2, -1), "-|>", label: text(0.7em)[`TimedHop`], label-side: left, label-pos: 0.35, stroke: (thickness: .6pt, dash: "dotted"))
      edge((1, 0), (2, 1), "-|>", label: text(0.7em)[`TimedHop`], label-side: right, label-pos: 0.35, stroke: (thickness: .6pt, dash: "dotted"))
      edge((2, -1), (3, 0), "-|>", label: text(0.7em)[`Vec<Formants>`], label-pos: 0.5)
      edge((2, 1), (3, 0), "-|>", label: text(0.7em)[`Vec<Pitch>`], label-pos: 0.45, label-side: right)
      edge((3, 0), (3, 1), "-|>", label: text(0.7em)[`MessageToWorker`], label-pos: 0.5, label-side: left)
    }
  ))
  }))
]

== Everything the app needs, in one place

#slide(composer: (4fr, 5fr))[
- Data as *Dioxus Signal with `SyncStorage`*
- Written in async tasks, when message from workers are received
- Read and modified by UI operations: recording start/stop, playback start, etc.
- All UI content is derived from it
][
  ```rs
  #[derive(Clone, Copy, PartialEq)]
  pub struct Controller {
      pub session: Signal<usize, SyncStorage>,
      pub app_state: Signal<AppState, SyncStorage>,
      pub recording: Signal<Recording, SyncStorage>,
      pub formants_pred: Signal<TimeStampedSeries<Formants>, SyncStorage>,
      pub pitch_pred: Signal<TimeStampedSeries<Pitch>, SyncStorage>,
      // ...
  }
  ```
]

= Other stuff

== A quick list of things

- ML inference is optimized using ONNX Execution Providers
- UI updates are batched and coordinated to reduce rendering workload
- Tailwind CSS is used for styling
- Lots of messy platform-specific workarounds due to `Dioxus` still being not mature enough

== CI/CD pipeline for cross-platform release

#slide[
  #align(center, box({
    // provenance note in the empty top-right corner
    place(top + right, text(
      size: 16pt,
      fill: rgb("#5c5f77"),
      align(right)[
        Source code stays on Tangled. \
        GitHub only holds the CI config, \
        releases and user-facing docs.
      ],
    ))

    text(size: 16pt, fletcher-diagram(
      node-stroke: .5pt,
      edge-stroke: .6pt,
      node-fill: rgb("#f0f4f8"),
      node-inset: 5pt,
      spacing: (30pt, 36pt),
      {
        // triggers
        node((0, -1), align(center)[
          *push / PR*
        ], shape: fletcher.shapes.pill, inset: 12pt, fill: rgb("#e8ebf2"))
        node((1, -1), align(center)[
          *Tangled CI* \
          #text(size: 0.8em)[`fmt.yml` · nixery\ `check.yml` · microvm]
        ], fill: rgb("#e3ecf7"))

        node((0, 1), align(center)[
          *push tag* #text(size: 0.85em)[`v*`]
        ], shape: fletcher.shapes.pill, inset: 12pt, fill: rgb("#e8ebf2"))
        node((1, 1), align(center)[
          *Tangled release* \
          #text(size: 0.8em)[`release.yml` · nixery\ Send CircleCI API request]
        ], fill: rgb("#e3ecf7"))
        node((2, 1), align(center)[
          *CircleCI* \
          #text(size: 0.8em)[`build-linux` · .deb .AppImage\ `build-macos` · .dmg\ `build-windows` · .msi .exe\ `build-android` · .apk]
        ], fill: rgb("#fdf3e3"))
        node((3, 1), align(center)[
          *publish* \
          #text(size: 0.8em)[waits for all 4\ SHA256SUMS]
        ], fill: rgb("#f3e8f4"))
        node((4, 1), align(center)[
          *GitHub Release* \
          #text(size: 0.8em)[`vX.Y.Z` + notes]
        ], fill: rgb("#e8f4e8"))

        // one trigger per flow, then a single release path
        edge((0, -1), (1, -1), "-|>")
        edge((0, 1), (1, 1), "-|>")
        edge((1, 1), (2, 1), "-|>")
        edge((2, 1), (3, 1), "-|>")
        edge((3, 1), (4, 1), "-|>")
      },
    ))
  }))
]

== It's now public on Github

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  image("imgs/sumigoe/release1.png", width: 80%),
  image("imgs/sumigoe/release2.png", width: 70%)
)

== The question I cannot avoid

*How much LLM did I use?*

- A lot but also not a lot (yes)
- At the beginning, I intentionally avoided LLM code generation, mostly used it for learning and discussing plans.
- Later when the codebase is mostly in shape, I started to use it more to modify code, and it was especially helpful for the _messy platform-specific workarounds_.

#pause
*Using cheaper, open models is helpful for my learning*

- Models I usually use: GLM-5.3 Flash, Deepseek v4.1 Flash
- I am "forced" to closely review LLM output, pushback against bad parts of its plan, and form my own judgement along the way.
