class ListsController < ApplicationController

  def index
    lists = @current_user.boards.first.lists.includes(:cards)
    # this includes statement is not working
    cards = lists.map { |list| list.cards  }
    if lists
      render json: { lists: lists, cards: cards }, status: 200
    else
      render json: { errors: { id: "Couldn't find Lists for user" } }, status: 422
    end
  end

  def show
    list = List.find_by(id: params[:id])
    cards = list.cards
    if list
      render json: { list: list, cards: cards }, status: 200
    else
      render json: { errors:
                      { id: "Couldn't find List with id " + params[:id]
                        }
                      }, status: 422
    end
  end

  def create
    list = List.new(list_params)
    if list.save
      render json: list, status: 201
    else
      render json: { errors:
                     { name: "organization name can't be blank and must have 3 or more characters",
                       position_id: "position_id can't be blank and must be a number",
                       board_id: "board_id can't be blank and must be a number"}
                     }, status: 422
    end
  end

  def update
    list = List.where(id: params[:id]).first
    if list.update(list_params)
      render json: list, status: 200
    else
      render json: { errors:
                     { name: "organization name can't be blank and must have 3 or more characters",
                       position_id: "position_id can't be blank and must be a number",
                       board_id: "board_id can't be blank and must be a number"}
                     }, status: 422
    end
  end

  def destroy
    list = List.where(id: params[:id]).first
    if list
      list.destroy
      render json: { success: "list destroyed"}, status: 200
    else
      render json: { errors: {
                     id: "list #{params[:id]} not found, failed to destroy"}
                     }, status: 422
    end
  end

  private
  def list_params
    params.require(:list).permit(:board_id, :name, :position_id)
  end
end
