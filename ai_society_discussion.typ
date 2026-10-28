#import "@preview/touying:0.8.0": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly

#set text(
  font: "Fira Sans",
  weight: "light",
  size: 20pt,
)
#show raw: set text(font: "FiraCode Nerd Font Mono")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  // catppuccin latte
  config-colors(
    primary: rgb("#dc8a78"),
    primary-light: rgb("#dc8a78"),
    secondary: rgb("#dd7878"),
    neutral-lightest: rgb("#eff1f5"),
    neutral-dark: rgb("#5c5f77"),
    neutral-darkest: rgb("#4c4f69"),
  ),
  // align: horizon,
  // config-common(handout: true),
  config-info(
    title: [Anthropomorphism and Public Discourse around AI],
    subtitle: [AI and Society Reading Group],
    author: [Kei Tang],
    date: datetime.today(),
    institution: [Recurse Center],
    // contact: [contact\@mail.com],
    logo: emoji.octopus,
  ),
  config-common(new-section-slide-fn: none)
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

= Intro

== You may have seen...

#block(width: 700pt, height: 300pt, stroke: 0pt + gray)[
  #place(center + horizon, dx: -200pt)[
    #image("imgs/ai_and_society/ava.jpeg", width: 200pt)
  ]
  #pause
  #place(center + horizon, dx: 200pt, dy: 0pt)[
    #image("imgs/ai_and_society/sitch.jpeg", width: 300pt)
  ]
  #pause
  #place(center + horizon, dx: 0pt, dy: -50pt)[
    #image("imgs/ai_and_society/notion.jpg", width: 500pt)
  ]
  #pause
  #place(center + horizon, dx: 0pt, dy: 50pt)[
    #image("imgs/ai_and_society/friend.jpg", width: 300pt)
  ]
]

#footnote[Images credit: https://thevalleyofai.com/]

== You may have also seen...

#block(width: 700pt, height: 300pt, stroke: 0pt + gray)[
  #place(center + horizon, dx: -130pt)[
    #image("imgs/ai_and_society/fortune_rogue.png", width: 400pt)
  ]
  #pause
  #place(center + horizon, dx: 100pt, dy: -80pt)[
    #image("imgs/ai_and_society/bbc_phd.png", width: 450pt)
  ]
  #pause
  #place(center + horizon, dx: 50pt, dy: 80pt)[
    #image("imgs/ai_and_society/science_pain.png", width: 450pt)
  ]
]

= The concept

== Definition

The previous images are examples of AI Anthropomorphization:

/ Anthropomorphization\/Anthropomorphism: Attribution of human-like feelings, mental states, and behavioral characteristics to artificial intelligence systems

== Categories of anthropomorphization

According to _Inie et al._#footnote[https://doi.org/10.5210/fm.v31i2.14366]:

1. *Cognizer*: `"The model can understand/learn..."`
2. *Product of cognition*: `"Hallucination", "The AI makes mistakes..."`, claims about "PhD level" intelligence
3. *Emotion*: `"The AI struggles with...", "Emphathetic"`, the friend ad
4. *Communication*: `"Prompt/Answer", "Conversational agent"`
5. *Agency*: `"The AI helps/supports/assists..."`, headlines about rogue AI
6. *Human role analogy*: `"AI tutor/assistant/writer/therapist..."`, the notion ad
7. *Names and pronouns*: Ava, Sitch, Devin...
8. *Biological metaphors*: `"Feeding the AI more data", "working tirelessly"`

== Risks of anthropomorphization (To users)

1. *Misplaced trust and over-reliance*: People who are presented with anthropomorphic descriptions of “AI” systems might attribute human-like reasoning and ethical judgments to the systems, which they inherently lack.
2. *Spillover effects*: Based on the perception of a system as having advanced cognitive “capabilities” in one area (such as producing text or code), users may overestimate functionalities in areas not directly demonstrated.
3. *Disproportionate impact*: Certain vulnerable groups suffer from more negative impacts, e.g. AI psychosis.

== Risks of anthropomorphization (To policy)

Anthropomorphization also appears in a legislative context#footnote[https://www.brookings.edu/articles/anthropomorphic-ai-terms-create-gaps-in-accountability/]:
#quote(block: true)[
  AI Impersonation Prevention Act of 2025 (H.R. 4628): Defines AI as software that “performs tasks normally requiring human intelligence,” including models producing “human-like” outputs.
]

1. *Questions on accountability*: The framing obscures the humans and institutions behind the design, training and deployment of AI systems.
2. *Risks on implementation*: It creates potential ambiguity over how the law should be applied.
3. *Reinforce industry narratives*: Technology firms have strong incentives to market products as intelligent, conversational, or agentic to drive adoption.

= Discussion

== Discussion questions

- At an individual level, when we talk about AI, what kinds of language change is beneficial, and when does it become too clunky?
- From our perspectives of technical practitioners, what can/should be done to better inform the public on the capabilities and limitations of AI systems?
- As a society, what should we do about AI applications that aim to provoke emotional attachment from the user?

Also,
- How do you interact with LLMs? Do you "talk" to it like a human?
- How do you feel about adding LLMs as co-author on git commits?#footnote[Claude code automatically adds itself onto git commit messages: https://github.com/anthropics/claude-code/issues/47579]
