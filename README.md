# From Topics to Toxicity

### Analysing and detecting misogyny in *The Real World* with topic modelling and large language models

**Authors:** Phung Banh, Daniel Commerford Guerra, Gijs van den Akster, Julian Adam, and Luca Torricelli  
**Course:** Computational Analysis of Digital Communication  
**Institution:** Vrije Universiteit Amsterdam  
**Course period:** Fall 2024 (Period 2)  

## Overview

This repository contains the final group project for the Vrije Universiteit Amsterdam course *Computational Analysis of Digital Communication*. The project investigates whether computational analysis methods can be used to detect hate speech in online community messages. Leaked chat logs from Andrew Tate's paid online platform, *The Real World*, serve as the empirical case study.

The analysis combines structural topic modelling with large-language-model classification. Topic modelling was used to identify recurring themes across user and staff conversations, while an LLM-based classification workflow assessed whether sampled messages contained misogynistic, racist, homophobic, or other hateful content.

The project was completed during the course's third cycle, in which students independently designed and conducted a data-analytical study. Its results were presented through an A0 research poster and a seven-minute pitch at the course mini-conference.

## Research question

> Can computational analysis methods be used to detect hate speech in online community messages?

To answer this overarching question, the project explored how messages could be categorized into recurring topics and whether LLM-based classification could identify misogynistic and other hateful content.

## Course context

The course introduced computational approaches for studying digital communication. It covered importing and wrangling data, exploratory text analysis, dictionary methods, supervised machine learning, transformer models, and zero- and few-shot classification with large language models.

This final project applied that methodological pipeline to assess the usefulness of computational methods for detecting hate speech:

1. importing and restructuring semi-structured digital trace data;
2. cleaning and preparing a large text corpus;
3. exploring latent themes with unsupervised topic modelling;
4. classifying potentially hateful content with an LLM; and
5. communicating the research design and findings visually.

## Data

The original material consisted of leaked chat logs associated with *The Real World*. Three subsets were selected:

- **The Real World main chat:** general user conversations;
- **Health & Fitness chat:** user discussions about training, nutrition, and related topics; and
- **Admin Group Chat:** staff and administrator conversations.

The raw files stored individual messages as JSON-like records in `.txt` files. They were parsed, standardized, converted to CSV, and combined by channel before analysis.

The underlying chat data are **not included** in this repository. The material contains personal identifiers, private communications, and potentially harmful content arising from a data breach; redistributing it would create serious ethical, privacy, and legal concerns.

## Methodology

### 1. Data preparation

The workflow used `jsonlite`, `tidyverse`, and `data.table` to:

- parse message records line by line;
- harmonize inconsistent fields;
- remove nested columns that were not required for the analysis;
- convert Unix timestamps into readable date-time values; and
- merge channel-specific CSV files.

### 2. Structural topic modelling

Messages were prepared with the `stm` package by converting text to lowercase, removing punctuation, numbers, and stop words, and stemming terms. Separate Structural Topic Models were then estimated for the selected chat samples, with eight latent topics requested for each model.

The analysis used topic-word probabilities, FREX terms, word clouds, topic correlations, and comparative plots to interpret the resulting themes.

### 3. LLM-assisted classification

A random sample of messages was classified into five categories:

| Code | Category |
|---:|---|
| 0 | Not hateful |
| 1 | Misogynistic |
| 2 | Racist |
| 3 | Homophobic |
| 4 | Other hateful content |

The poster analysis used GPT-3.5 Turbo. The accompanying technical report subsequently demonstrated the workflow with a locally hosted Llama 3.1 8B model through `tidyllm`, allowing a larger sample to be processed without external API costs.

## Main findings

The exploratory topic models identified recurring discussions concerning:

- fitness, workouts, nutrition, and protein;
- motivation, discipline, and self-improvement;
- work, productivity, and money;
- relationships and social interaction; and
- everyday plans and routines.

The classification results shown in the poster indicated that most sampled messages were classified as not hateful. The model nevertheless identified some misogynistic content and a smaller amount of homophobic or otherwise hateful material.

These findings are exploratory. They describe the sampled messages and the outputs of the selected models; they do not establish the prevalence of such attitudes among all platform members.

## Repository contents

```text
VU-CADC-Topics-to-Toxicity/
├── README.md
├── LICENSE
├── .gitignore
├── report/
│   └── Group-assignment_Final.html
└── poster/
    └── Research-Design-Poster-A0.jpg
```

The HTML report is self-contained and can be downloaded and opened in any modern browser. It preserves the submitted analytical workflow, R code, model output, and visualizations. The poster summarizes the research design and headline findings presented at the mini-conference.

## Reproducibility and limitations

The submitted HTML output documents the code and results, but the original `.Rmd` source and raw chat datasets are not available in this repository. A complete rerun therefore requires reconstructing the RMarkdown document and obtaining the source data through an appropriate, lawful research process.

Additional limitations include:

- the use of samples rather than the complete message corpus;
- sensitivity of topic-model outputs to preprocessing choices and the selected number of topics;
- possible classification error and model bias in the LLM-generated labels;
- limited construct validity when inferring misogyny or hate speech from short messages without their conversational context; and
- an apparent coding error in the preserved report: `admin_data2` is sampled from `csv_data_main` rather than `csv_data_admin`, meaning the reported Admin topic model may not represent the intended Admin dataset.

## Ethical note

This repository is provided for academic documentation and methodological transparency. It does not endorse Andrew Tate, *The Real World*, or the views expressed in the analysed messages. No raw leaked messages or personal data are redistributed here.

## Acknowledgements

This project was completed for *Computational Analysis of Digital Communication* at Vrije Universiteit Amsterdam, coordinated by Dr. Philipp Masur, with practical instruction from Dr. Kasper Welbers, Emma Diel, and Roan Buma.

## Licence

The original code and documentation in this repository are released under the [MIT License](LICENSE). This licence does not apply to the underlying chat data or to third-party materials depicted or referenced in the submitted project artifacts.
