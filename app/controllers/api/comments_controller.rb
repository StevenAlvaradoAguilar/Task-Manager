class Api::CommentsController < ApplicationController
  def index
    # Encuentra la característica asociada usando el parámetro :feature_id de la ruta
    feature = Feature.find(params[:feature_id])
    # Encontrar el comentario asociado a la característica
    comments = feature.comments
    render json: comments, status: :ok
  end
end
