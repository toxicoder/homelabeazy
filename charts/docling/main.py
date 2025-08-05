from fastapi import FastAPI
from pydantic import BaseModel
from docling.document_converter import DocumentConverter

app = FastAPI()

class ConversionRequest(BaseModel):
    source: str

@app.post("/convert/")
async def convert_document(request: ConversionRequest):
    """
    Accepts a source URL or file path and returns the converted document in Markdown format.
    """
    try:
        converter = DocumentConverter()
        result = converter.convert(request.source)
        return {"markdown": result.document.export_to_markdown()}
    except Exception as e:
        return {"error": str(e)}
