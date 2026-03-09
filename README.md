# QLoRA Qwen Finetune

This project implements fine-tuning of the Qwen2.5-7B language model for Named Entity Recognition (NER) tasks in the medical domain using QLoRA (Quantized Low-Rank Adaptation).

## Project Overview

The project fine-tunes Qwen2.5-7B to extract medical entities from text. The model is trained to identify and classify entity types such as diseases, symptoms, treatments, drugs, and other medical-related terms from input sentences.

## Model Architecture

- **Base Model**: Qwen/Qwen2.5-7B
- **Fine-tuning Method**: QLoRA (4-bit quantization with LoRA adapters)
- **LoRA Configuration**:
  - Rank (r): 8
  - Alpha: 16
  - Dropout: 0.05
  - Target modules: q_proj, k_proj, v_proj, o_proj, gate_proj, up_proj, down_proj

## Dataset

The project uses a medical NER dataset with the following structure:
- Training data: `data/medical.train` / `data/medical_train.jsonl`
- Validation data: `data/medical.dev` / `data/medical_val.jsonl`
- Test data: `data/medical.test` / `data/medical_test.jsonl`

### Data Format

Raw data format (`.train`, `.dev`, `.test`):
```
Word TAG
Word TAG
...
```

Where TAG follows BIO tagging scheme (e.g., B-Disease, I-Disease, O).

JSON format (`.jsonl`):
```json
{
    "sentence": "The patient has fever and cough",
    "entity_info": [
        {"entity_text": "fever", "entity_label": "Symptom"},
        {"entity_text": "cough", "entity_label": "Symptom"}
    ]
}
```

## Installation

### Prerequisites

- Python 3.9+
- CUDA-compatible GPU (recommended for training)

### Setup

1. Clone the repository:
```bash
git clone git@github.com:SunnyKikiHK/QLora_Qwen_Finetune.git
cd QLora_Qwen_Finetune
```

2. Create and activate virtual environment:
```bash
conda create -n transformers python=3.9
conda activate transformers
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Configure environment variables:
Create a `.env` file with your WANDB API key:
```
WANDB_API_KEY=your_api_key_here
```

## Usage

### Training

Run the Jupyter notebook `train_qwen2.5_sft.ipynb` which contains the complete training pipeline:

1. Import libraries and initialize wandb tracking
2. Load and preprocess dataset
3. Download Qwen2.5-7B model from ModelScope
4. Apply LoRA configuration
5. Train the model
6. Evaluate on validation set

### Training Configuration

Default training parameters:
- Batch size: 4 (per device)
- Gradient accumulation steps: 4
- Learning rate: 1e-4
- Epochs: 2
- Max sequence length: 512
- Save steps: 100
- Evaluation steps: 50

### Inference

After training, load the fine-tuned model for inference:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel

# Load base model
model = AutoModelForCausalLM.from_pretrained(
    "./qwen/Qwen/Qwen2___5-7B",
    device_map="auto",
    torch_dtype=torch.bfloat16
)

# Load LoRA adapter
p_model = PeftModel.from_pretrained(model, model_id="./output/Qwen2.5-7B/checkpoint-658")
tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen2.5-7B")
```

## Evaluation

The evaluation script calculates Precision, Recall, and F1-score for each entity type using micro-averaging. Results are displayed in a formatted table showing per-class metrics and overall performance.

## Project Structure

```
QLora_Qwen_Finetune/
├── train_qwen2.5_sft.ipynb   # Main training notebook
├── prompts.py                 # System prompt templates
├── requirements.txt           # Python dependencies
├── setup_env.sh              # Environment setup script
├── data/
│   ├── medical.train         # Raw training data
│   ├── medical_train.jsonl   # JSON training data
│   ├── medical.dev           # Raw validation data
│   ├── medical_val.jsonl     # JSON validation data
│   ├── medical.test          # Raw test data
│   └── medical_test.jsonl    # JSON test data
├── output/                   # Model checkpoints directory
└── qwen/                     # Downloaded model cache
```

## Dependencies

- torch >= 2.0.0
- transformers >= 4.36.0
- datasets >= 2.14.0
- peft >= 0.7.0
- bitsandbytes >= 0.41.0
- wandb >= 0.15.0
- modelscope

## License

This project is for educational and research purposes.